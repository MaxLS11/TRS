// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC721/IERC721.sol";
import "@openzeppelin/contracts/utils/introspection/ERC165.sol";
import "@openzeppelin/contracts/token/ERC721/IERC721Receiver.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol";
import "@openzeppelin/contracts/utils/Strings.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/IERC721Enumerable.sol";

    contract Trees is IERC721, ERC165, IERC721Enumerable, IERC721Metadata, Ownable {

        using Strings for uint;
        mapping(uint => address) _owners;
        mapping(address => uint) _balances;
        mapping(uint => address) _tokenApprovals;
        string public baseURI;

        modifier _requireMinted(uint256 tokenId) {
        require(_exists(tokenId),"not minted");
        _; 
       }

    constructor (string memory _name, string memory _symbol) IERC721(_name, _symbol) {
        _name = _name;
        _symbol = _symbol;
    }

        function balanceOf(address owner) public view returns(uint256) {
            require(owner != address(0), "zero address");
            return _balances[owner];
    }

        function safeTransferFrom(address from, address to, uint tokenId) public {
            require(_isApprovedOrOwner(msg.sender,tokenId),"not an owner or approved!"); //!public 
            _safeTransfer(from, to, tokenId);
    }
        function transferFrom(address from, address to, uint256 tokenId) external {
            require (_isApprovedOrOwner(msg.sender, tokenId), "not an owner or approved!");
            _transfer(from, to, tokenId);
    } 

        function _isApprovedOrOwner(address spender, uint tokenId) internal view returns (bool){
            address owner = OwnerOf(tokenId);
            require(spender == owner) ||
            isApproveForAll[owner]; 
     }

        function OwnerOf(uint tokenId) public _requireMinted(tokenId) returns (address) {
            return _owners[tokenId];

        function isApprovedForAll(address owner) public view returns (bool) {
            return _tokenApprovals(owner, spender);
    }
 
    }
        function _safeTransfer(address from, address to, uint256 tokenId) internal {
            _transfer(from, to, tokenId);
            require(_checkOnERC721Received(from, to, tokenId), "non erc721 receiver");
    }
    function getApproved(uint tokenId) public view _requireMinted(tokenId) returns(address) {
        return _tokenApprovals(tokenId);
    }

    function _checkOnERC721Received(address from, address to, uint256 tokenId) private returns(bool) {
        if(to.code.length > 0) {
            try IERC721Receiver(to).onERC721Received(msg.sender, from, tokenId, bytes("")) returns(bytes4 ret) {
                return ret == IERC721Receiver.onERC721Received.selector;
            } catch(bytes memory reason) {
                if(reason.length == 0) {
                    revert("Non erc721 receiver!");
                } else {
                    assembly {
                        revert(add(32,reason), mload(reason))
                    }

                }
            }
        } else {
                return true;
        }
    }
    
    function _transfer(address from,address to, uint tokenId) internal {
        require(OwnerOf(tokenId) == from, "not an owner!");
        require(to != address(0),"to cannot be zero!");
        _beforeTokenTransfer(from, to, tokenId);
        _balances[from]--;
        _balances[to]++;
        _owners[tokenId] = to;

        emit Transfer(from, to, tokenId);
        _afterTokenTransfer(from, to, tokenId);   //!
    }
        function _beforeTokenTransfer(address from, address to, uint256 tokenId) internal override(IERC721, IERC721Enumerable) {
                super._beforeTokenTransfer(from, to, tokenId);
    } 
        function _afterTokenTransfer(address from, address to, uint256 tokenId) internal virtual {} 

        function supportsInterface(bytes4 interfaceId)public view override(IERC721, IERC721Enumerable)returns (bool) {
            return interfaceId == type(IERC721).interfaceId ||
            super.supportsInterface(interfaceId);
    }
        
        function withdraw() public payable onlyOwner {
            uint256 balance = address(this).balance;
            require(balance > 0, "No ether left to withdraw");
            (bool success, ) = (msg.sender).call{value: balance}("");
            require(success, "Transfer failed.");
    }
        function _exists(uint256 tokenId) internal view returns(bool) {
            return _owners[tokenId] != address(0);
            }

        function approve(address to, uint tokenId) public {
            address _owner = OwnerOf(tokenId);
            require(_owner == msg.sender || isApprovedForAll(_owner,msg.sender), "not an owner");
            require(to != _owner, "cannot approve to self");
            _tokenApprovals[tokenId] = to;
            emit Approval(owner, to, tokenId);
        }
   
    function burn(uint tokenId) public virtual {

        require(_isApprovedOrOwner(msg.sender, tokenId), "not an owner");
        address owner = OwnerOf[tokenId];
        _balances[owner]--;
        delete _owners[tokenId];
    }
    function _mint(address to, uint tokenId) internal virtual {
        require( to != address(0), "to canndo be zero");
        require(!_exists(tokenId), "already exists" );
        owner[tokenId] = to;
        _balances[to]++;
    }
       function _safeMint(address to,uint tokenId) internal virtual {
           _mint(to, tokenId);
           require (_checkOnERC721Received(msg.sender, to, tokenId), "non ERC721 receiver!");
       }


       function _baseURI() internal pure virtual override returns (string memory) {
           return "";
    }
        
       function tokenURI(uint tokenId ) public _requireMinted(tokenId) view returns(string memory) {

           string memory baseURI = _baseURI();
           return bytes(baseURI).length > 0 ?
           string(abi.encodePacked(baseURI, tokenId.toString)) :
           "";
       }

    }
