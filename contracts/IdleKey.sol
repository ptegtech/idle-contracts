// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "./interface/IIdleKey.sol";
import "./base/SecurityBase.sol";

contract IdleKey is IIdleKey, ERC721URIStorage, ERC721Enumerable, SecurityBase
{
    using Counters for Counters.Counter;
    Counters.Counter private _tokenIds;

    uint256 private _MAX_SUPPLY = 48000;
    
    event KeyCreated(uint256 tokenId, address owner);
    event KeyCounterUpdated(uint256 tokenId);

    constructor() ERC721("IdleKey", "IDK") {
    }

    function maxSupply() public view returns (uint256) {
        return _MAX_SUPPLY;
    }

    function currentId() public view override returns (uint256) {
        return _tokenIds.current();
    }

    function isSoldOut() public view override returns (bool) {
        return (_tokenIds.current() >= _MAX_SUPPLY);
    }

    function incrementCounter(uint256 n) public whenNotPaused onlyMinter returns (uint256) {
        uint256 _currentId = _tokenIds.current();
        require(_currentId + n <= _MAX_SUPPLY, "Over max supply");
        for (uint256 i=0; i<n; i++) {
            _tokenIds.increment();
            _currentId = _tokenIds.current();
            emit KeyCounterUpdated(_currentId);
        }
        return _currentId;
    }

    function safeMintKeys(address to, uint256 count) public whenNotPaused onlyMinter override {
        uint256 lastId = _tokenIds.current();
        require(count <= 10, "Count max: 10");
        require((lastId + count) < _MAX_SUPPLY, "MAX SUPPLY");
        for (uint i=0; i<count; i++) {
            _tokenIds.increment();
            uint256 tokenId = _tokenIds.current();
            _safeMint(to, tokenId);
            emit KeyCreated(tokenId, to);
            emit KeyCounterUpdated(tokenId);
        }
    }

    function safeMintKey(address to) public whenNotPaused onlyMinter override returns (uint256) {
        uint256 lastId = _tokenIds.current();
        require(lastId < _MAX_SUPPLY, "MAX SUPPLY");
        _tokenIds.increment();
        uint256 tokenId = _tokenIds.current();
        _safeMint(to, tokenId);
        emit KeyCreated(tokenId, to);
        emit KeyCounterUpdated(tokenId);
        return tokenId;
    }

    function burn(uint256 tokenId) public whenNotPaused override {
        require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721Burnable: caller is not owner nor approved");
        _burn(tokenId);
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
    
}
