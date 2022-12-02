//SPDX-License-Identifier: MIT
pragma solidity 0.8.17;

import "@openzeppelin/contracts/utils/introspection/IERC165.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/token/ERC721/IERC721.sol";
import "@openzeppelin/contracts/security/ReentrancyGuard.sol";

contract  Legacy is ReentrancyGuard {
    struct Recepient {
        address receiver;
        uint8 sharePercentBps;
        uint denominator;
        uint id;
    }

    struct Asset {
        address assetAddress;
        Recepient[] recepients;
    }

    mapping(address => Asset[]) private _wills;
    mapping(address => uint32) private _expiresAt;

    event WillCreated(
        address indexed testator, 
        uint32 createdAt, 
        uint32 expiresAt
    );
    event WillExecuted(
        address indexed testator, 
        uint32 expiredAt,
        uint32 executedAt
    );

    function createWill(Asset[] memory assets, uint32 expiresAt) external nonReentrant {
        Asset[] storage wills = _wills[msg.sender];

        require(expiresAt > block.timestamp, "expire time too small");
        validateAsset(assets);

        _expiresAt[msg.sender] = expiresAt;
        for(uint i = 0; i < assets.length; i++) {
            wills.push(assets[i]);
        }

        emit WillCreated(msg.sender, uint32(block.timestamp), expiresAt)
    }

    function executeWill(address testator) external nonReentrant {
        Asset[] memory wills = _wills[testator];
        uint32 expiredAt = _expiresAt[testator];

        for(uint i = 0; i < wills.length; i++) {
            Asset memory asset = wills[i];
            if(
                IERC165(asset.assetAddress).supportsInterface(
                    type(IERC721).interfaceId
                )
            ) {
                _handleERC721Asset(testator, asset);
            }
            else {
                _handleERC20Asset(testator, asset);
            }
        }

        delete _wills[testator];
        delete _expiresAt[testator];

        emit WillExecuted(testator, uint32(block.timestamp), expiredAt);
    }

    function validateAsset(Asset[] memory assets) internal {
        for(uint i = 0; i < assets.length) {
            require(assets[i].assetAddress != address(0), "zero assets address");
            require(assets[i].assetAddress.code.length > 0, "address not contract");

            for(uint j = 0; j < assets.recepients.length; j++) {
                Recepient recepient = assets[i].recepients[j];
                require(
                    recepient.receiver != address(0), 
                    "zero recepient address"
                );
                if(IERC165(assets[i].assetAddress).supportsInterface(
                    type(IERC721).interfaceId
                )) {
                    require(recepient.id != 0, "zero token id");
                    require(
                        msg.sender == IERC721(assets[i].assetAddress).ownerOf(
                            recepient.id
                        ), "caller not token owner"
                    );
                }
                else {
                    require(recepient.sharePercentBps > 0, "share percentage < 0");
                    require(recepient.denominator >= 100, "percentage should be in bps");
                }
            }
        }
    }

    function _handleERC20Asset(address testator, Asset memory asset) internal {
        uint balance = IERC20(asset.assetAddress).balanceOf(testator);
        for(uint i = 0; i < asset.recepients.length; i++) {
            uint amount = (balance * asset.allowance[i]) / asset.denominator[i];
            if(amount > 0) {
                _handleERC20Transfer(
                    asset.assetAddress, 
                    testator, 
                    asset.recepients[i], 
                    amount
                );
            }
        }
    }

    function _handleERC721Asset(address testator, Asset memory asset) internal {
        for(uint i = 0; i < asset.ids.length; i++) {
            _handleERC721Transfer(
                asset.assetAddress, 
                asset.ids[i], 
                testator, 
                asset.recepients[i]
            );
        }
    }
    
    function _handleERC20Transfer(
        address token,
        address from,
        address to,
        uint amount
    ) private {
        IERC20(token).transferFrom(from, to, amount);
    }

    function _handleERC721Transfer(
        address token,
        uint tokenId,
        address from,
        address to
    ) private {
        IERC721(token).safeTransferFrom(from, to, tokenId);
    }
}