// SPDX-License-Identifier: CC0-1.0
pragma solidity ^0.8.5;


import {ILSP1UniversalReceiver} from "./ILSP1UniversalReceiver.sol";
import {LSP8IdentifiableDigitalAssetCore} from "./LSP8IdentifiableDigitalAsset.sol";
import {EnumerableSet} from "@openzeppelin/contracts/utils/structs/EnumerableSet.sol";
import {ILSP1UniversalReceiver} from "./ILSP1UniversalReceiver.sol";
import {IERC165} from "@openzeppelin/contracts/utils/introspection/IERC165.sol";
import {IERC725Y} from "@erc725/smart-contracts/contracts/interfaces/IERC725Y.sol";
import {ERC165Checker} from "./ERC165Checker.sol";
import {LSP4DigitalAssetMetadata} from "./contracts/LSP4DigitalAssetMetadata/LSP4DigitalAssetMetadata.sol";
import {_INTERFACEID_LSP1} from "../LSP1UniversalReceiver/LSP1Constants.sol";
import "./LSP8Errors.sol";
import "./LSP8Constants.sol";
import "./utils/Strings.sol";
import "./LSP4Constants.sol";
import "./LSP4Errors.sol";


contract TreesNFT is ILSP8IdentifiableDigitalAsset, LSP4DigitalAssetMetadata {

        using Strings for uint256;
        mapping(bytes32 => address) internal _tokenOwners;
        
        event ValueReceived(address sender, uint256 amount);
    constructor(string memory name_, string memory symbol_) LSP4DigitalAssetMetadata("The Trees NFT", "TRS") {
    
        super._setData(_LSP4_SUPPORTED_STANDARDS_KEY, _LSP4_SUPPORTED_STANDARDS_VALUE);

        super._setData(_LSP4_TOKEN_NAME_KEY, bytes(name_));
        super._setData(_LSP4_TOKEN_SYMBOL_KEY, bytes(symbol_));
    
    }
    
    
    function _setData(bytes32 dataKey, bytes memory dataValue) internal virtual override {
        if (dataKey == _LSP4_TOKEN_NAME_KEY) {
            revert LSP4TokenNameNotEditable();
        } else if (dataKey == _LSP4_TOKEN_SYMBOL_KEY) {
            revert LSP4TokenSymbolNotEditable();
        } else {
            store[dataKey] = dataValue;
            emit DataChanged(
                dataKey,
                dataValue.length <= 256 ? dataValue : BytesLib.slice(dataValue, 0, 256)
            );
        }
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
    
    function _exists(bytes32 tokenId) internal view virtual returns (bool) {
        return _tokenOwners[tokenId] != address(0);
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
    
    receive() external payable {
        emit ValueReceived(msg.sender, msg.value);
    }

    function supportsInterface(bytes4 interfaceId) public view virtual override(IERC165, IERC725Y) returns (bool) {
        return interfaceId == _INTERFACEID_LSP8 || super.supportsInterface(interfaceId);
    }






}
