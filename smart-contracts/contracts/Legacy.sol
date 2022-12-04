// SPDX-License-Identifier: MIT
pragma solidity 0.8.17;

import "@openzeppelin/contracts/utils/introspection/IERC165.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/token/ERC721/IERC721.sol";
import "@openzeppelin/contracts/security/ReentrancyGuard.sol";

interface ILegacy {
    struct Recepient {
        address receiver;
        uint8 sharePercentBps;
        uint denominator;
        uint id;
    }
    struct Asset {
        address assetAddress;
        uint8 assetType;
        uint32 expiresAt;
        uint allowance;
        Recepient[] recepients;
    }
    function createWill(Asset memory asset) external;
    function executeWill(address testator, address assetAddress) external;
}
contract  Legacy is ReentrancyGuard {
    struct Recepient {
        address receiver;
        uint8 sharePercentBps;
        uint denominator;
        uint id;
    }

    struct Asset {
        address assetAddress;
        uint8 assetType;
        uint32 expiresAt;
        uint allowance;
        Recepient[] recepients;
    }

    mapping(address => mapping(address => Asset)) public wills;
    // mapping(address => uint32) private _expiresAt;

    event WillCreated(
        address indexed testator, 
        address assestAddress,
        uint8 assetType,
        uint32 createdAt, 
        uint32 expiresAt
    );
    event WillExecuted(
        address indexed testator, 
        address assetAddress,
        uint8 assetType,
        uint32 expiresAt,
        uint32 executedAt
    );
    event UpdatedExpiresAt(
        address indexed testator, 
        address assetAddress,
        uint32 expiresAt
    );
    event WillDeleted(
        address indexed testator, 
        address assetAddress
    );
    function createWill(Asset memory asset) external nonReentrant {
        require(asset.expiresAt > uint32(block.timestamp), "expire time too small");
        validateAsset(asset);

        Asset storage will = wills[msg.sender][asset.assetAddress];
        for(uint j = 0; j < asset.recepients.length; j++) {
            will.recepients.push(Recepient({
                receiver: asset.recepients[j].receiver,
                sharePercentBps: asset.recepients[j].sharePercentBps,
                denominator: asset.recepients[j].denominator,
                id: asset.recepients[j].id
            }));
        }
        will.assetAddress = asset.assetAddress;
        will.expiresAt = asset.expiresAt;
        will.allowance = asset.allowance;
        
        emit WillCreated(msg.sender, asset.assetAddress, asset.assetType, uint32(block.timestamp), asset.expiresAt);
    }

    function executeWill(address testator, address assetAddress) external nonReentrant {
        Asset memory will = wills[testator][assetAddress];

        require(will.expiresAt <= block.timestamp,"Too early");
        if(
            IERC165(will.assetAddress).supportsInterface(
                type(IERC721).interfaceId
            )
        ) {
            _handleERC721Asset(testator, will);
        }
        else {
            _handleERC20Asset(testator, will);
        }

        delete wills[testator][assetAddress];

        emit WillExecuted(testator, assetAddress, will.assetType, uint32(block.timestamp), will.expiresAt);
    }

    function updateExpiresAt(address assetAddress, uint32 expiresAt) external nonReentrant {
        Asset storage asset = wills[msg.sender][assetAddress];
        
        require(asset.assetAddress == assetAddress, "will dose not exist");
        require(expiresAt > uint32(block.timestamp), "expire time too small");

        asset.expiresAt = expiresAt;

        emit UpdatedExpiresAt(msg.sender, assetAddress, expiresAt);
    }

    function deleteWill(address assetAddress) external nonReentrant {
        Asset memory asset = wills[msg.sender][assetAddress];
        
        require(asset.assetAddress == assetAddress, "will dose not exist");

        delete wills[msg.sender][assetAddress];

        emit WillDeleted(msg.sender, assetAddress);
    }

    function validateAsset(Asset memory asset) internal view {

        require(asset.assetAddress != address(0), "zero asset address");
        require(asset.assetAddress.code.length > 0, "address not contract");

        for(uint j = 0; j < asset.recepients.length; j++) {
            Recepient memory recepient = asset.recepients[j];
            require(
                recepient.receiver != address(0), 
                "zero recepient address"
            );
            if(asset.assetType == 1) {
                require(recepient.id != 0, "zero token id");
                require(
                    msg.sender == IERC721(asset.assetAddress).ownerOf(
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

    function _handleERC20Asset(address testator, Asset memory asset) internal {
        uint balance = IERC20(asset.assetAddress).balanceOf(testator);
        if(balance > asset.allowance) {
            balance = asset.allowance;
        }
        for(uint i = 0; i < asset.recepients.length; i++) {
            Recepient memory recep = asset.recepients[i];
            uint amount = (balance * recep.sharePercentBps) / recep.denominator;
            if(amount > 0) {
                _handleERC20Transfer(
                    asset.assetAddress, 
                    testator, 
                    recep.receiver, 
                    amount
                );
            }
        }
    }

    function _handleERC721Asset(address testator, Asset memory asset) internal {
        for(uint i = 0; i < asset.recepients.length; i++) {
            Recepient memory recep = asset.recepients[i];
            _handleERC721Transfer(
                asset.assetAddress, 
                recep.id, 
                testator, 
                recep.receiver
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