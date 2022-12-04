//SPDX-License-Identifier: MIT
pragma solidity 0.8.17;
import "./Legacy.sol";
contract LegacyResolver {
    Legacy public legacy;
    function checker(address _legacy, address owner, address assetAddress)
        external
        returns (bool canExec, bytes memory execPayload)
    {   
        legacy = Legacy(_legacy);
        (, , uint32 expiry, ) = (legacy.wills(owner, assetAddress));

        canExec = (expiry - block.timestamp) < 0;
        
        execPayload = abi.encodeCall(ILegacy.executeWill, (owner, assetAddress));
    }
}