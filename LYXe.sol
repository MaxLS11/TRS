// SPDX-License-Identifier: CC0-1.0
pragma solidity ^0.8.0;


import {IERC165} from "@openzeppelin/contracts/utils/introspection/IERC165.sol";
import {IERC725Y} from "@erc725/smart-contracts/contracts/interfaces/IERC725Y.sol";


import {_INTERFACEID_LSP8} from "./LSP8Constants.sol";

contract Trees is IERC165, ERC725YCore, LSP4DigitalAssetMetadata, LSP8IdentifiableDigitalAssetCore {

    constructor(string memory name_, string memory symbol_, address newOwner_) LSP4DigitalAssetMetadata(name_, symbol_, newOwner_) {
    
    
    } 

    function supportsInterface(bytes4 interfaceId)public view virtual override(IERC165, ERC725YCore)returns (bool)
    {
        return interfaceId == _INTERFACEID_LSP8 || super.supportsInterface(interfaceId);
    }
    
    
    
    
    
    
    
}
