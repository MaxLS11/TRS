// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC721/IERC721.sol.";
import "@openzeppelin/contracts/utils/introspection/IERC165.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol";
import "@openzeppelin/contracts/utils/Strings.sol";
//import "@openzeppelin/contracts/utils/math/SafeMath.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol";

contract Trees is ERC721, IERC165, IERC721Enumerable, IERC721Metadata, Ownable {
    
    using Strings for uint;
    uint public constant maxPurchase = 3;
    uint256 public constant MAX_TREES = 100;
    //uint256 private _treesPrice = - 
    string private baseURI;
    bool public saleIsActive = true;
    string public _name;
    string public _symbol; 
    string public  _tokenId;
    bool public saleIsActive = true;
    string public baseTokenURI;
    mapping(address => uint) _balances;
    mapping(uint => address) _owners;
    modifier _requireMinted(uint tokenId) {
        require(_exists(tokenId),"not minted");
        _;
    }
    constructor (string memory _name, string memory _symbol) {
        Trees = _name;
        TRS = _symbol;
       
    }

        function balanceOf(address owner) public view returns(uint) {
            require(owner != address(0), "zero address");
            return _balances[owner];
    }
    
        function ownerOf(uint tokenId) public view _requireMinted(tokenId) returns(address) {
            return _owners[tokenId];
    }
        function safeTransferFrom(address from, address to, uint tokenId) public {
            require(_isApprovedOrOwner(msg.sender,tokenId),"not an owner or approved!"); //!public 
            _safeTransfer(from, to, tokenId);
    }
        function transferFrom(address from, address to, uint tokenId) external {
            require (_isApprovedOrOwner(msg.sender, tokenId), "not an owner or approved!");
            _transfer(from, to, tokenId);
    } 
        function _safeTransfer(address from, address to, uint tokenid) internal {
            _transfer(from, to, tokenId);
            require(_checkOnERC721Received(from, to, tokenId), "non erc721 receiver");
    }
    
    function _checkOnERC721Received(address from, address to, uint tokenId) private returns(bool) {
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
        require(ownerOf(tokenId) == from, "not an owner!");
        require(to != address(0),"to cannot be zero!");
        _beforeTokenTransfer(from, to, tokenId);
        _balances[from]--;
        _balances[to]++;
        _owners[tokenId] = to;

        emit Transfer(from, to, tokenId);
        _afterTokenTransfer(from, to, tokenId);   //!
    }
        function _beforeTokenTransfer(address from, address to, uint tokenId) internal override(ERC721, ERC721Enumerable) {
                super._beforeTokenTransfer(from, to, tokenId);
    } 
        function _afterTokenTransfer(address from, address to, uint tokenId) internal virtual {} 

        function supportsInterface(bytes4 interfaceId)public view override(ERC721, ERC721Enumerable)returns (bool) {
            return interfaceId == type(IERC721).interfaceId ||
            super.supportsInterface(interfaceId);
    }
        function setPrice(uint256 _newPrice) public onlyOwner() {
            _trssePrice = _newPrice;
    }
        function getPrice() public view returns (uint256){
            return _treesPrice;
    }
        function withdraw() public payable onlyOwner {
            uint balance = address(this).balance;
            require(balance > 0, "No ether left to withdraw");
            (bool success, ) = (msg.sender).call{value: balance}("");
            require(success, "Transfer failed.");
    }
        function _exists(uint tokenId) internal view returns(bool) {
            return _owners[tokenId] != address(0); //proverka vvoda v oborot(est token or no)
        }
        function _mintTrees(address to, uint tokenId) public virtual payable {
            require(to != address(0), "to cannot be zero"); 
            require(!_exists(tokenId), "already exists!");
            _owners[tokenId] = to;
            _balances[to]++;
            require(saleIsActive, "Sale must be active to mint Trees");
            require(numberOfTokens <= maxPurchase, "Can only mint 3 tokens at a time");
            require(totalSupply().add(numberOfTokens) <= MAX_TREES, "Purchase would exceed max supply of Trees");
            require(_treesPrice.mul(numberOfTokens) <= msg.value, "Ether value sent is not correct");
            for(uint i = 0; i < numberOfTokens, i++) {
            uint mintIndex = totalSupply();
            if (totalSupply() < MAX_TREES) {
                _safeMint(msg.sender, mintIndex);
                emit _mintTrees(msg.sender,_tokenId;)
            }
        }
    }

        function _safeMint(address to,uint tokenId) internal virtual {
            _mint(to, tokenId);
            require(_chekOnERC721Received(msg.sender, to, tokenId),"non ERC721 receiver!");
    }
    
        function tokenURI(uint tokenId) public _requireMinted(tokenId) view returns(string memory) {
            string memory baseURI; //ipfs:
            return bytes(baseURI).length > 0 ?
            string(abi.encodePacked(baseURI, tokenId.toString())) :
            "";
    }

        constructor(string memory baseURI) ERC721("The Trees NFT", "TRS") {
            return setBaseURI(baseURI);
    }
        function _baseURI() internal pure virtual override returns (string memory) {
            return baseTokenURI; //!
    }
        function _setBaseURI(string memory baseTokenURI) public onlyOwner {
            baseTokenURI = _baseTokenURI; // BaseTokenURI = newBaseURI;
    }

        function _setTokenURI(uint256 tokenId, string _tokenURI) {
            require tokenId;
    }
        function tokenOfOwnerByIndex(address owner, uint256 index) external {
            uint256 tokenId;
    }
    
}

// Woou. 
