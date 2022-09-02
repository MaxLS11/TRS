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
        
    constructor(string memory name_, string memory symbol_)  {
       
    }

    function totalSupply() public view override returns (uint256) {

        return _existingTokens;
    }

    function balanceOf(address tokenOwner) public view override returns (uint256) {
        return _ownedTokens[tokenOwner].length();
    }

    function tokenOwnerOf(bytes32 tokenId) public view override returns (address) {
        address tokenOwner = _tokenOwners[tokenId];

        if (tokenOwner == address(0)) {
            revert LSP8NonExistentTokenId(tokenId);
        }

        return tokenOwner;
    }

        function tokenIdsOf(address tokenOwner) public view override returns (bytes32[] memory) {
        return _ownedTokens[tokenOwner].values();
    }


    function _transfer(address from, address to, bytes32 tokenId, bool force, bytes memory data) internal virtual {
        if (from == to) {
            revert LSP8CannotSendToSelf();
        }

        address tokenOwner = tokenOwnerOf(tokenId);
        if (tokenOwner != from) {
            revert LSP8NotTokenOwner(tokenOwner, tokenId, from);
        }

        if (to == address(0)) {
            revert LSP8CannotSendToAddressZero();
        }
    }
    
    
    

    function _existsOrError(bytes32 tokenId) internal view {
        if (!_exists(tokenId)) {
            revert LSP8NonExistentTokenId(tokenId);
        }
    }


    function _notifyTokenSender(address from, address to, bytes32 tokenId, bytes memory data) internal virtual {
        if (ERC165Checker.supportsERC165Interface(from, _INTERFACEID_LSP1)) {
            bytes memory packedData = abi.encodePacked(from, to, tokenId, data);
            ILSP1UniversalReceiver(from).universalReceiver(_TYPEID_LSP8_TOKENSSENDER, packedData);
        }
    }

    function _notifyTokenReceiver(address from, address to, bytes32 tokenId, bool force, bytes memory data) internal virtual {
        if (ERC165Checker.supportsERC165Interface(to, _INTERFACEID_LSP1)) {
        bytes memory packedData = abi.encodePacked(from, to, tokenId, data);
        ILSP1UniversalReceiver(to).universalReceiver(_TYPEID_LSP8_TOKENSRECIPIENT, packedData);

      } else if (!force) {
            if (to.code.length != 0) {
                revert LSP8NotifyTokenReceiverContractMissingLSP1Interface(to);
          } else {
                revert LSP8NotifyTokenReceiverIsEOA(to);
            }
        }
    }







}
