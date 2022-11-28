//SPDX-License-Identifier: MIT
pragma solidity 0.8.17;

import "@openzeppelin/contracts/interfaces/IERC165.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/token/ERC721/IERC721.sol";
import "@openzeppelin/contracts/token/ERC1155/IERC1155.sol";

contract  Legacy {
    struct Asset {
        address assetAddress;
        address[] recepients;
        uint32[] allowance;
        uint[] denominator;
        uint[] ids;
        uint[] amount;
    }

    mapping(address => Asset[]) private _wills;

    function createWill(Asset[] memory assets) external {
        Asset[] storage wills = _wills[msg.sender];
        for(uint i = 0; i < assets.length; i++) {
            wills.push(assets[i]);
        }
    }

    function executeWill(address testator) external {
        Asset[] memory wills = _wills[testator];

        for(uint i = 0; i < wills.length; i++) {
            Asset memory asset = wills[i];
            if(
                IERC165(asset.assetAddress).supportsInterface(
                    type(IERC721).interfaceId
                )
            ) {
                _handleERC721Asset(testator, asset);
            }
            else if(
                IERC165(asset.assetAddress).supportsInterface(
                    type(IERC1155).interfaceId
                )
            ) {
                _handleERC1155Asset(testator, asset);
            }
            else {
                _handleERC20Asset(testator, asset);
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

    function _handleERC1155Asset(address testator, Asset memory asset) internal {
        for(uint i = 0; i < asset.recepients.length; i++) {
            uint balance = IERC1155(asset.assetAddress).balanceOf(
                testator, 
                asset.ids[i]
            );
            uint amount = (balance * asset.allowance[i]) / asset.denominator[i];

            if(amount > 0) {
                _handleERC1155Transfer(
                    asset.assetAddress, 
                    asset.ids[i], 
                    amount, 
                    testator, 
                    asset.recepients[i]
                );
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

    function _handleERC1155Transfer(
        address token,
        uint tokenId,
        uint amount,
        address from,
        address to
    ) private {
        IERC1155(token).safeTransferFrom(from, to, tokenId, amount, "");
    }
}