// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "./interface/IIdleHero.sol";
import "./base/SecurityBase.sol";

contract IdleHero is IIdleHero, ERC721URIStorage, ERC721Enumerable, SecurityBase
{
    using Counters for Counters.Counter;
    Counters.Counter private _tokenIds;

    // Mapping from token ID to hero dna
    mapping(uint256 => NFTHero) private _heroMap;

    struct NFTHero{
        uint256 dna;
        uint256[] parents;
        uint256[] childs;
        uint256 bornCount;
    }

    event HeroCreated(uint256 tokenId, address owner, uint256 dna);
    event Received(address from, uint256 amount);

    constructor() ERC721("IdleHero", "IDH") {
    }
    
    receive() external payable {
        emit Received(msg.sender, msg.value);
    }

    // safe minted hero to address
    function safeMintHero(address to, uint256 dna) public whenNotPaused onlyMinter override returns (uint256) {
        _tokenIds.increment();
        uint256 tokenId = _tokenIds.current();
        _safeMint(to, tokenId);
        _setHeroDNA(tokenId, dna);
        emit HeroCreated(tokenId, to, dna);
        return tokenId;
    }

    function _setHeroDNA(uint256 tokenId, uint256 dna) internal whenNotPaused onlyMinter {
        NFTHero memory nfthero;
        nfthero.dna = dna;
        nfthero.bornCount = 0;
        _heroMap[tokenId] = nfthero;
    }

    function _beforeTokenTransfer(address from, address to, uint256 tokenId)
        internal
        whenNotPaused
        override(ERC721, ERC721Enumerable)
    {
        super._beforeTokenTransfer(from, to, tokenId);
    }

    function _burn(uint256 tokenId) internal whenNotPaused override(ERC721, ERC721URIStorage) {
        super._burn(tokenId);
    }

    function heroDNA(uint256 tokenId)
        public
        view
        override
        returns (uint256)
    {
        return _heroMap[tokenId].dna;
    }

    function heroParents(uint256 tokenId)
        public
        view
        override
        returns (uint256[] memory)
    {
        return _heroMap[tokenId].parents;
    }

    function heroChilds(uint256 tokenId)
        public
        view
        override
        returns (uint256[] memory)
    {
        return _heroMap[tokenId].childs;
    }

    function heroBornCount(uint256 tokenId)
        public
        view
        override
        returns (uint256)
    {
        return _heroMap[tokenId].bornCount;
    }

    function tokenURI(uint256 tokenId)
        public
        view
        override(ERC721, ERC721URIStorage)
        returns (string memory)
    {
        return super.tokenURI(tokenId);
    }

    function supportsInterface(bytes4 interfaceId)
        public
        view
        override(ERC721, ERC721Enumerable, SecurityBase)
        returns (bool)
    {
        return super.supportsInterface(interfaceId);
    }
    
    function checkOwenr(address to, uint256 tokenId) public view override returns(bool){
        if (ownerOf(tokenId) == to){
            return true;
        }
        return false;
    }

    function checkBornCount(uint256 parentIDA, uint256 parentIDB) public view override returns(bool){
        if ((_heroMap[parentIDA].bornCount > 6) || (_heroMap[parentIDB].bornCount > 6)){
            return false;
        }
        return true;
    }

    function addParentsChilds(uint256 parentIDA, uint256 parentIDB, uint256 tokenId) public whenNotPaused onlyMinter override {
        _heroMap[tokenId].parents = [parentIDA, parentIDB];
        _heroMap[parentIDA].bornCount++;
        _heroMap[parentIDB].bornCount++;
        _heroMap[parentIDA].childs.push(tokenId);
        _heroMap[parentIDB].childs.push(tokenId);
    }
}
