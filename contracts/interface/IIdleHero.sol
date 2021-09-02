// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

// IdleHero contract interface
interface IIdleHero {
    function safeMintHero(address to, uint256 dna) external returns (uint256);
    function checkOwenr(address to, uint256 tokenId) external returns(bool);
    function checkBornCount(uint256 parentIDA, uint256 parentIDB) external returns(bool);
    function addParentsChilds(uint256 parentIDA, uint256 parentIDB, uint256 tokenId) external;
    function heroDNA(uint256 tokenId) external view returns (uint256);
    function heroParents(uint256 tokenId) external view returns (uint256[] memory);
    function heroChilds(uint256 tokenId) external view returns (uint256[] memory);
    function heroBornCount(uint256 tokenId) external view returns (uint256);
}
