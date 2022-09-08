// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.5;

import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol";
import "@openzeppelin/contracts/utils/Strings.sol";


    contract TreesNFT is ERC721Enumerable, Ownable {


        using Strings for uint256;
        string public baseURI;
        string public notRevealedUri;
        uint256 public _treesPrice = 0;
        uint256 public maxSupply = 100;
        uint256 public maxMintAmount = 2;
        uint256 public nftPerAddressLimit = 2;
        string public baseExtension = "json";
        bool public revealed = false;
        mapping(address => uint256) public addressMintedBalance;
        event ValueReceived(address sender, uint256 amount);

      constructor(string memory _name, string memory _symbol, string memory _initBaseURI, string memory _initNotRevealedUri) ERC721("TreesNFT", "TRS") {
            setBaseURI(_initBaseURI);
            setNotRevealedURI(_initNotRevealedUri);
  }

        receive() external payable {
            emit ValueReceived(msg.sender, msg.value);
    }

  function mint(uint256 _mintAmount) public payable {
  
    uint256 supply = totalSupply();
    require(_mintAmount > 0, "need to mint at least 1 TreesNFT");
    require(_mintAmount <= maxMintAmount, "max mint amount per session exceeded");
    require(supply + _mintAmount <= maxSupply, "max NFT limit exceeded");

    if (msg.sender != owner()) {
            uint256 ownerMintedCount = addressMintedBalance[msg.sender];
            require(ownerMintedCount + _mintAmount <= nftPerAddressLimit, "max NFT per address exceeded");
            require(msg.value >= _treesPrice * _mintAmount, "insufficient funds");
    }

    for (uint256 i = 1; i <= _mintAmount; i++) {
      addressMintedBalance[msg.sender]++;
      _safeMint(msg.sender, supply + i);
    }
  }
  
    function walletOfOwner(address _owner) public view returns (uint256[] memory) {
        uint256 ownerTokenCount = balanceOf(_owner);
        uint256[] memory tokenIds = new uint256[](ownerTokenCount);
            for (uint256 i; i < ownerTokenCount; i++) {
            tokenIds[i] = tokenOfOwnerByIndex(_owner, i);
    }
                return tokenIds;
  }

    function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
        require(
            _exists(tokenId), "ERC721Metadata: URI query for nonexistent token"
    );
    
            if(revealed == false) {
                return notRevealedUri;
    }

            string memory currentBaseURI = _baseURI();
            return bytes(currentBaseURI).length > 0 ? string(abi.encodePacked(currentBaseURI, tokenId.toString(), baseExtension)): 
            
            "";
  }

    function reveal() public onlyOwner {
        revealed = true;
  }
  
    function setNftPerAddressLimit(uint256 _limit) public onlyOwner {
        nftPerAddressLimit = _limit;
  }
  
    function setPrice(uint256 _newPrice) public onlyOwner {
        _treesPrice = _newPrice;
  }

    function setmaxMintAmount(uint256 _newmaxMintAmount) public onlyOwner {
        maxMintAmount = _newmaxMintAmount;
  }

    function setBaseURI(string memory _newBaseURI) public onlyOwner {
        baseURI = _newBaseURI;
  }

    function setBaseExtension(string memory _newBaseExtension) public onlyOwner {
        baseExtension = _newBaseExtension;
  }
  
    function setNotRevealedURI(string memory _notRevealedURI) public onlyOwner {
        notRevealedUri = _notRevealedURI;
  }

    function _baseURI() internal view virtual override returns (string memory) {
        return baseURI;
  }

    function withdraw() public payable onlyOwner {

        (bool os, ) = payable(owner()).call{value: address(this).balance}("");
            require(os);
   
  }
}
