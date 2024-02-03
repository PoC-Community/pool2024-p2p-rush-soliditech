// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import {ERC721} from "../lib/openzeppelin-contracts/contracts/token/ERC721/ERC721.sol";
import {IERC721Metadata} from "../lib/openzeppelin-contracts/contracts/token/ERC721/extensions/IERC721Metadata.sol";
import {Ownable} from "../lib/openzeppelin-contracts/contracts/access/Ownable.sol";
import {Strings} from "../lib/openzeppelin-contracts/contracts/utils/Strings.sol";
import {IERC721} from "../lib/openzeppelin-contracts/contracts/token/ERC721/IERC721.sol";
import {IERC165} from "../lib/openzeppelin-contracts/contracts/utils/introspection/IERC165.sol";
import {IERC721Metadata} from "../lib/openzeppelin-contracts/contracts/token/ERC721/extensions/IERC721Metadata.sol";

contract NFTek is IERC721Metadata, ERC721, Ownable {
    string internal baseURI;
    uint256 internal MAXNFT;
    uint256 internal nbNft;
    uint256 public price;
    bool public saleState;
    string public nftName;
    string public nftSymbole;

    constructor(string memory _name, string memory _sym, string memory _startingBaseURI, uint256 _maxnft, uint256 _price) ERC721(_name, _sym) Ownable(msg.sender) {
        baseURI = _startingBaseURI;
        MAXNFT = _maxnft;
        price = _price;
        saleState = true;
        nftName = _name;
        nftSymbole = _sym;
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
    function tokenURI(uint256 tokenId) public view override(ERC721, IERC721Metadata) returns (string memory) {
        require(tokenId <= nbNft, "wrong tokenId");
        return string(abi.encodePacked(baseURI, Strings.toString(tokenId)));
    }
    function name() public view override(ERC721, IERC721Metadata) returns (string memory) {
        return nftName;
    }
    function symbol() public view override(ERC721, IERC721Metadata) returns (string memory) {
        return nftSymbole;
    }
    function supportsInterface(bytes4 interfaceId) public view virtual override(ERC721, IERC165) returns (bool) {
        return
            interfaceId == type(IERC721).interfaceId ||
            interfaceId == type(IERC721Metadata).interfaceId ||
            interfaceId == bytes4(0x49064906) ||
            super.supportsInterface(interfaceId);
    }
}