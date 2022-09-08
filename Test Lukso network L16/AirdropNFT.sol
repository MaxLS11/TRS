
//SPDX-License-Identifier: MIT
pragma solidity ^0.8.5;


import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/Strings.sol";
import "hardhat/console.sol";

contract TreesNFT is ERC721Enumerable, Ownable {
    using Strings for uint256;
    using Counters for Counters.Counter;
    Counters.Counter private _tokenIds;
    event ValueReceived(address sender, uint256 amount);
    
    constructor() ERC721("The Trees NFT ", "TRS") {

        console.log("Contract has been deployed!");
    }

    function airdropNfts(address[] calldata wAddresses) public onlyOwner {

        for (uint i = 0; i < wAddresses.length; i++) {
            _mintSingleNFT(wAddresses[i]);
        }
    }
    
    function _mintSingleNFT(address wAddress) private {
        uint newTokenID = _tokenIds.current();
        _safeMint(wAddress, newTokenID);
        _tokenIds.increment();
    }

      receive() external payable {
            emit ValueReceived(msg.sender, msg.value);
        }
}
