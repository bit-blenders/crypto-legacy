//SPDX-License-Identifier: MIT
pragma solidity 0.8.17;

import "@openzeppelin/contracts/utils/introspection/IERC165.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/token/ERC721/IERC721.sol";
import "@openzeppelin/contracts/security/ReentrancyGuard.sol";

contract LegacyV2 {

    error AssetExists();

    uint4 private constant ERC20 = 1;
    uint4 private constant ERC721 = 2;
    bytes4 private constant ERC721_INTERFACE_ID = type(IERC721).interfaceId;


    struct Will {
        uint4 assetType,
        uint32 expiresAt;
        uint allowance;
        bytes32 merkleRoot;
    }

    mapping(address => address => Will) private _will;
    mapping(address => address => address => bool) private _hasClaimed;

    event WillCreated(
        address indexed testator,
        address indexed asset,
        uint32 createdAt, 
        uint32 expiresAt
    );
    event TokensClaimed(
        address indexed testator,
        address indexed asset,
        address indexed recepient,
        uint amount,
        uint tokenId
    );

    function createWill(
        address asset, 
        uint32 expiresAt,
        uint allowance; 
        bytes32 merkleRoot
    ) external {
        Will storage will = _will[msg.sender][asset];

        require(will.assetType == 0, "asset already exists");
        require(
            asset != address(0) && asset.code.length > 0, 
            "non-contract asset address"
        );
        require(expiresAt > uint32(block.timestamp), "expire time too small");
        require(merkleRoot != bytes32(0), "empty merkle root");

        if(IERC165(asset).supportsInterface(ERC721_INTERFACE_ID)) {
            require(
                IERC721(asset).isApprovedForAll(msg.sender, address(this)),
                "Legacy is not an operator"
            );
        }
        else {
            (bool success, ) = asset.call(
                abi.encodeWithSignature("balanceOf(address)", msg.sender)
            );
        }
    }

    function claimAsset(
        address testator,
        address asset,
        address recepient,
        uint8 shareBps,
        uint denominator,
        uint tokenId
        bytes32[] calldata proof
    ) external {}
}