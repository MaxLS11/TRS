// SPDX-License-Identifier: MIT
pragma solidity ^0.8.5;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/utils/Context.sol";
import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/utils/Strings.sol";



    contract TreesNFT is ERC721, ERC721Enumerable, Ownable {

        
        uint256 public constant maxMintAmount = 1;
        uint256 public constant max_Supply = 100;
        using Strings for uint256;
        uint256 private _treesPrice = 80000000000000000; //test
        string private baseURI;
        event ValueReceived(address sender, uint256 amount);
        bool public saleIsActive = true;

    constructor() ERC721("The Trees NFT", "TRS") {

    }
    

           receive() external payable {
            emit ValueReceived(msg.sender, msg.value);
        }

    function supportsInterface(bytes4 interfaceId) public view override(ERC721, ERC721Enumerable) returns (bool){
        return super.supportsInterface(interfaceId);
    }

	function withdraw() public onlyOwner {
			uint256 balance = address(this).balance;
			payable(msg.sender).transfer(balance);
		}    

    function setPrice(uint256 _newPrice) public onlyOwner() {
        _treesPrice = _newPrice;
    }

    function getPrice() public view returns (uint256){
        return _treesPrice;
    }

    function mint(uint256 _mintAmount) public payable {
        uint256 supply = totalSupply();
        //require(!paused);
        require(_mintAmount > 0);
        require(_mintAmount <= maxMintAmount);
        require(supply + _mintAmount <= max_Supply);

            if (msg.sender != owner()) {
              require(msg.value >= _treesPrice * _mintAmount);
    }

    for (uint256 i = 1; i <= _mintAmount; i++) {
      _safeMint(msg.sender, supply + i);
    }
  }
   
    function _baseURI() internal view override returns (string memory) {
        return baseURI;
    }
    
    function setBaseURI(string memory newBaseURI) public onlyOwner {
        baseURI = newBaseURI;
    }

    function _beforeTokenTransfer(address from, address to, uint256 tokenId)
        internal
        override(ERC721, ERC721Enumerable)
    {
        super._beforeTokenTransfer(from, to, tokenId);
    }

    function flipSaleState() public onlyOwner {
        saleIsActive = !saleIsActive;
    }

}
