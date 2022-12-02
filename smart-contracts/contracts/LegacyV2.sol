//SPDX-License-Identifier: MIT
pragma solidity 0.8.17;

contract LegacyV2 {

    enum AssetType {
        ERC20,
        ERC721
    }

    struct Will {
        AssetType assetType,
        uint32 expiresAt;
        bytes32 merkleRoot;
    }

    mapping(address => address => Will) private _will;

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
        uint amount
    );
    event TokenClaimed(
        address indexed testator,
        address indexed asset,
        address indexed recepient,
        uint tokenId
    );

    function createWill(
        address asset, 
        uint32 expiresAt, 
        bytes32 merkleRoot
    ) external {}

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