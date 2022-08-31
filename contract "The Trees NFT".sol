// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/Strings.sol";
import "@openzeppelin/contracts/token/ERC721/IERC721Receiver.sol";


contract TheTreesNFT is ERC721, Ownable {

    using Strings for uint256;
    uint256 public constant maxSupply = 100t
    uint256 public  constant maxMintAmount = 3;
    string  baseTokenURI;
    mapping (uint => address) _owners;
    mapping (address => uint256[]) nftOwner;
    mapping(address => uint) _balances;
    uint256[] soldedTokenIds;
    uint256 public _treesPrice = 8 LYXe;
    bool public saleIsActive = true;
    
    event _mint(address senderAddress, uint256 TreesNFT);

    constructor(string memory Trees, string memory TRS) ERC721("Trees", "TRS") {
        setBaseURI(baseURI);
  
    }
  
    function _baseURI() internal view virtual override returns (string memory) {
        return baseTokenURI; 
    }

    function setBaseURI(string memory _baseTokenURI) public onlyOwner {
        baseTokenURI = _baseTokenURI;
    
    }
    
    function balanceOf(address owner) public view returns(uint256) {
        require(owner != address(0), "zero address");
        return _balances[owner];
    }
    
    function withdraw() public payable onlyOwner {
        uint256 balance = address(this).balance;
        require(balance > 0, "No ether left to withdraw");
        (bool success, ) = (msg.sender).call{value: balance}("");
        require(success, "Transfer failed.");
    }

    modifier checkTokenStatus(uint256 tokenId) {
        bool isTokenSold = false;
        for (uint256 i = 0; i < soldedTokenIds.length; i++) {
        if(soldedTokenIds[i] == tokenId) {
            isTokenSold = true;
                break;
        }
    }
            require(!isTokenSold, "Token is sold");
            _;
}
    modifier _requireMinted(uint256 tokenId) {
        require(_exists(tokenId),"not minted");
        _;
    }
    function _exists(uint256 tokenId) internal view returns(bool) {
        return _owners[tokenId] != address(0);
        }

    function tokenURI(uint256 tokenId) public _requireMinted(tokenId) view returns(string memory) {
        string memory baseURI = _baseURI;
        return bytes(baseURI).length > 0 ?
        string(abi.encodePacked(baseURI, tokenId.toString())) :
        "";
    }

    function _mint(uint256 numberOfTokens) public payable {
        require(saleIsActive, "Sale must be active to mint token");
        require(numberOfTokens <= maxMintAmount, "Can only mint 3 tokens at a time");
        require(totalSupply().add(numberOfTokens) <= maxSupply, "Purchase would exceed max supply of Trees");
        require(_treesPrice.mul(numberOfTokens) <= msg.value, "LYXe value sent is not correct");
        
        for(uint256 i = 0; i < numberOfTokens; i++) {
            uint256 mintIndex = totalSupply();
            if (totalSupply() < maxSupply) {
                _safeMint(msg.sender, mintIndex);
            }
        }
    }      


    function _safeMint(address to,uint256 tokenId) internal virtual {
            _mint(to, tokenId);
            require(_checkOnERC721Received(msg.sender, to, tokenId),"non ERC721 receiver!");
    }
   
    function _transfer(address from,address to, uint256 tokenId) internal {
        require(ownerOf(tokenId) == from, "not an owner!");
        require(to != address(0),"to cannot be zero!");
        _beforeTokenTransfer(from, to, tokenId);
        _balances[from]--;
        _balances[to]++;
        _owners[tokenId] = to;

        emit Transfer(from, to, tokenId);
        _afterTokenTransfer(from, to, tokenId); 
    }
        function ownerOf(uint256 tokenId) public view _requireMinted(tokenId) returns(address) {
            return _owners[tokenId];
        }

    function _safeTransfer(address from, address to, uint256 tokenId) internal {
            _transfer(from, to, tokenId);
            require(_checkOnERC721Received(from, to, tokenId), "non ERC721 receiver");
    }

    function _checkOnERC721Received(address from, address to, uint256 tokenId) private returns(bool) {
        if(to.code.length > 0) {
            try ERC721Receiver(to).onERC721Received(msg.sender, from, tokenId, bytes("")) returns(bytes4 ret) {
                return ret == ERC721Receiver.onERC721Received.selector;
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

   
}
