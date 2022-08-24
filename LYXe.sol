// SPDX-License-Identifier: CC0-1.0
pragma solidity ^0.8.0;


import from "@openzeppelin/contracts/utils/introspection/IERC165.sol";
import from "@Lukso/LSP8IdentifiableDigitalAssetCore.sol";
import from "@Lukso/LSP4DigitalAssetMetadata/LSP4DigitalAssetMetadata.sol";
import from "@erc725/smart-contracts/contracts/interfaces/IERC725Y.sol";


contract Trees  is IERC165, IERC725Y, LSP4DigitalAssetMetadata, LSP8IdentifiableDigitalAssetCore{

    function supportsInterface(bytes4 interfaceId)public view virtual override(IERC165, ERC725YCore)
        returns (bool)
    {
        return interfaceId == _INTERFACEID_LSP8 || 
        super.supportsInterface(interfaceId);
    }
}

 constructor(string memory name_, string memory symbol_, address newOwner_) LSP4DigitalAssetMetadata(name_, symbol_, newOwner_) {
 
 
 
 
 
 }









}
