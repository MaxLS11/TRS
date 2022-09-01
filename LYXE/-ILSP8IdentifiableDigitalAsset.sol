// SPDX-License-Identifier: CC0-1.0
pragma solidity ^0.8.0;


import {ILSP1UniversalReceiver} from "../LSP1UniversalReceiver/ILSP1UniversalReceiver.sol";
import {ILSP8IdentifiableDigitalAsset} from "./ILSP8IdentifiableDigitalAsset.sol";
import {ERC725Y} from "@erc725/smart-contracts/contracts/ERC725Y.sol";
import {EnumerableSet} from "@openzeppelin/contracts/utils/structs/EnumerableSet.sol";
import {ILSP1UniversalReceiver} from "../LSP1UniversalReceiver/ILSP1UniversalReceiver.sol";
import {ERC165Checker} from "../Custom/ERC165Checker.sol";

import {_INTERFACEID_LSP1} from "../LSP1UniversalReceiver/LSP1Constants.sol";
import "./LSP8Errors.sol";

import "./utils/Strings.sol";


contract Trees is ILSP8IdentifiableDigitalAsset {

        using Strings for uint256;
        


        mapping(bytes32 => address) internal _tokenOwners;



    function _transfer(address from, address to, bytes32 tokenId, bool force, bytes memory data) public virtual {
        if (from == to) {
            revert LSP8CannotSendToSelf();
        }
}





}
