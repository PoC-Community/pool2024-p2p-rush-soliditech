// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import {ERC721} from "../lib/openzeppelin-contracts/contracts/token/ERC721/ERC721.sol";
import {Ownable} from "../lib/openzeppelin-contracts/contracts/access/Ownable.sol";

contract NFTek is ERC721, Ownable {
    string internal baseURI;
    uint256 internal MAXNFT;
    uint256 internal nbNft;
    uint256 public price;
    bool public saleState;

    constructor(string memory _startingBaseURI, uint256 _maxnft, uint256 _price) ERC721("NFTek", "NTEK") Ownable(msg.sender) {
        baseURI = _startingBaseURI;
        MAXNFT = _maxnft;
        price = _price;
        saleState = true;
    }

    function changeMaxNft(uint256 max) public onlyOwner {
        require(max > 0 && max > MAXNFT, "new max wrong");
        MAXNFT = max;
    }
    function getMaxNft() public view returns (uint256) {
        return MAXNFT;
    }
    function toggleSaleState() public onlyOwner {
        saleState = !saleState;
    }
    function mintNFTek(uint256 nbNewNft) public payable {
        require(saleState == true, "Sale off");
        require(nbNft + nbNewNft <= MAXNFT, "too many nft");
        require(nbNewNft * price == msg.value, " not enough ether given");
        for (uint256 i = 1; i <= nbNewNft; i++) {
            _safeMint(msg.sender, nbNft + i, "");
        }
        nbNft += nbNewNft;
    }
    function _baseURI() internal view virtual override returns (string memory) {
        return baseURI;
    }
    function getBaseURI() public view onlyOwner returns (string memory) {
        return baseURI;
    }
    function setBaseURI(string memory newURI) public onlyOwner {
        baseURI = newURI;
    }
    function setPrice(uint256 _price) public onlyOwner {
        price = _price;
    }
    function getPrice() public view returns (uint256) {
        return price;
    }
    function getNbNFTek() public view returns (uint256) {
        return nbNft;
    }
}