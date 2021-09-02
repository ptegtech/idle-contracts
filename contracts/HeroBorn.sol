// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./interface/IHeroGene.sol";
import "./interface/IIdleHero.sol";
import "./base/ERC721HeroCallerBase.sol";
import "./base/ERC20TokenCallerBase.sol";
import "./base/GeneCallerBase.sol";
import "./base/SecurityBase.sol";

contract HeroBorn is ERC721HeroCallerBase, ERC20TokenCallerBase, GeneCallerBase, SecurityBase {

    uint256 private _baseDNA = 111011127434030112131410101010203041122334402020203040514263646060603040506;
    uint256[] private bornTokenPriceList;

    constructor() {
        bornTokenPriceList = [100 ether, 200 ether, 300 ether, 500 ether, 800 ether, 1300 ether, 2100 ether];
    }

    function _checkHeroModifier(address caller) internal virtual override {
        _checkRole(MINTER_ROLE, caller);
    }

    function _checkTokenModifier(address caller) internal virtual override {
        _checkRole(MINTER_ROLE, caller);
    }

    function _checkRNGModifier(address caller) internal virtual override {
        _checkRole(MINTER_ROLE, caller);
    }

    function _checkGeneModifier(address caller) internal virtual override {
        _checkRole(MINTER_ROLE, caller);
    }

    function calcBornPrice(uint256 parentIDA, uint256 parentIDB) public view returns (uint256) {
        return _calcBornPrice(parentIDA, parentIDB);
    }

    function _calcBornPrice(uint256 parentIDA, uint256 parentIDB) internal view returns (uint256) {
        uint256 born_a_price = bornTokenPriceList[IIdleHero(_heroContract).heroBornCount(parentIDA)];
        uint256 born_b_price = bornTokenPriceList[IIdleHero(_heroContract).heroBornCount(parentIDB)];
        uint256 _bornTokenPrice = born_a_price + born_b_price;
        return _bornTokenPrice;
    }

    function generateRNGSeed() public {
        _generateRNGSeedTo(msg.sender);
    }

    function bornHero(uint256 parentIDA, uint256 parentIDB) public whenNotPaused heroReady token20Ready geneReady {
        _bornHeroTo(msg.sender, parentIDA, parentIDB);
    }

    function bornHeroTo(address to, uint256 parentIDA, uint256 parentIDB) public whenNotPaused heroReady token20Ready geneReady {
        _bornHeroTo(to, parentIDA, parentIDB);
    }

    function _bornHeroTo(address to, uint256 parentIDA, uint256 parentIDB) internal whenNotPaused heroReady token20Ready geneReady {
        require(to != address(0), "New hero owner could not be NullAddress");

        uint256 _bornTokenPrice = _calcBornPrice(parentIDA, parentIDB);

        uint256 tokenBalance = balanceOfERC20Token(msg.sender);
        require(tokenBalance >= _bornTokenPrice, "Token balance not enought");

        uint256 allowanceToken = allowanceOfERC20Token(msg.sender, address(this));
        require(allowanceToken >= _bornTokenPrice, "Token allowance not enough");

        transferERC20TokenFrom(msg.sender, address(this), _bornTokenPrice);

        require(IIdleHero(_heroContract).checkOwenr(msg.sender, parentIDA), "The sender is not the owner of NFT parent A");
        require(IIdleHero(_heroContract).checkOwenr(msg.sender, parentIDB), "The sender is not the owner of NFT parent B");
        require(IIdleHero(_heroContract).checkBornCount(parentIDA, parentIDB), "Parents born count must less than 7");

        uint256 parent_a_dna = IIdleHero(_heroContract).heroDNA(parentIDA);
        uint256 parent_b_dna = IIdleHero(_heroContract).heroDNA(parentIDB);
        uint256 newDNA = IHeroGene(_geneContract).getBornDNA(parent_a_dna, parent_b_dna, to);
        // _baseDNA = _baseDNA + 10;
        uint256 tokenId = _safeMintHero(to, newDNA);

        IIdleHero(_heroContract).addParentsChilds(parentIDA, parentIDB, tokenId);
    }
}
