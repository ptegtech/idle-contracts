const { assert } = require("chai");

const WETHToken = artifacts.require("WETHToken");
const ChildIdleHero = artifacts.require("ChildIdleHero");
const HeroMarket = artifacts.require("HeroMarket");

contract("test HeroMarket", async accounts => {
  let token;
  let hero;
  let hmarket;
  const acc0 = accounts[0];
  const acc1 = accounts[1];
  const acc2 = accounts[2];
  const acc3 = accounts[3];
  const zeroBN = new web3.utils.BN(0);
  const oneBN = new web3.utils.BN(1);
  const tokenPrice = new web3.utils.BN(2);
  const tokenPriceBN = web3.utils.toWei(tokenPrice, "ether");
  const BaseDNA = new web3.utils.BN("111011127434030112131410101010203041122334402020203040514263646060603040506");
  before(async function() {
    token = await WETHToken.deployed();
    hero = await ChildIdleHero.deployed();
    hmarket = await HeroMarket.deployed();
  });
  it("Mint WETH to account 1", async () => {
    const amount = 10000;
    const amountBN = new web3.utils.BN(amount);
    const mintAmount = web3.utils.toWei(amountBN, "ether");

    let balance = await token.balanceOf(acc1);
    assert.equal(balance.toString(), zeroBN.toString());
    await token.safeMint(acc1, mintAmount, {from: acc0});
    balance = await token.balanceOf(acc1);
    assert.equal(balance.toString(), mintAmount.toString());
  });
  it("Mint hero to account 2", async () => {
    const amount = 10000;
    const amountBN = new web3.utils.BN(amount);
    const dna1 = BaseDNA.clone().add(amountBN);
    let heroCount = await hero.balanceOf(acc2);
    assert.equal(heroCount.toString(), zeroBN.toString());

    await hero.safeMintHero(acc2, dna1);
    heroCount = await hero.balanceOf(acc2);
    assert.equal(heroCount.toString(), zeroBN.clone().add(oneBN).toString());

    let tokenId = await hero.tokenOfOwnerByIndex(acc2, 0);
    let owner1 = await hero.ownerOf(tokenId);
    assert.equal(owner1, acc2);
  });
  it("On sale for account 2", async () => {
    const tokenId = await hero.tokenOfOwnerByIndex(acc2, 0);

    await hero.setApprovalForAll(hmarket.address, true, { from: acc2 });
    const isApproved = await hero.isApprovedForAll(acc2, hmarket.address);
    assert.equal(isApproved, true);

    let totalSaleCount = await hmarket.totalSaleTokens();
    assert.equal(totalSaleCount.toString(), zeroBN.toString());

    await hmarket.createSale(tokenId, tokenPriceBN, { from: acc2 });
    totalSaleCount = await hmarket.totalSaleTokens();
    assert.equal(totalSaleCount.toString(), zeroBN.clone().add(oneBN).toString());
    let sellerSaleCount = await hmarket.sellerSalesCount(acc2);
    assert.equal(sellerSaleCount.toString(), zeroBN.clone().add(oneBN).toString());

    let saleTokenId = await hmarket.saleTokenByIndex(0);
    assert.equal(saleTokenId.toString(), tokenId.toString());

    saleTokenId = await hmarket.saleTokenOfSellerByIndex(acc2, zeroBN);
    assert.equal(saleTokenId.toString(), tokenId.toString());

    let { seller, price, startedAt } = await hmarket.getTokenOnSale(tokenId);
    assert.equal(seller, acc2);
    assert.equal(price.toString(), tokenPriceBN.toString());
    assert.notEqual(startedAt.toString(), zeroBN.toString());
  });
  it("Buy sale for account 1", async () => {
    const amount = 10000;
    const amountBN = new web3.utils.BN(amount);
    const mintAmount = web3.utils.toWei(amountBN, "ether");

    const lastTotalSaleCount = await hmarket.totalSaleTokens();
    assert.notEqual(lastTotalSaleCount.toString(), zeroBN.toString());

    const tokenId = await hmarket.saleTokenByIndex(0);
    const { seller, price, startedAt } = await hmarket.getTokenOnSale(tokenId);

    const tradeFee = await hmarket.getTokenTradeFee(tokenId);

    await token.approve(hmarket.address, mintAmount, { from: acc1 });
    const allowance = await token.allowance(acc1, hmarket.address);
    assert.equal(allowance.toString(), mintAmount.toString());

    const lastBuyerBalance = await token.balanceOf(acc1);
    const lastSellerBalance = await token.balanceOf(seller);
    const lastMarketBalance = await token.balanceOf(hmarket.address);
    await hmarket.buySale(tokenId, { from: acc1 });

    const owner = await hero.ownerOf(tokenId);
    assert.equal(owner, acc1);

    let buyerBalance = await token.balanceOf(acc1);
    assert.equal(lastBuyerBalance.sub(buyerBalance).toString(), price.toString());

    let sellerBalance = await token.balanceOf(seller);
    assert.equal(sellerBalance.sub(lastSellerBalance).toString(), zeroBN.clone().add(price).sub(tradeFee).toString());

    let marketBalance = await token.balanceOf(hmarket.address);
    assert.notEqual(marketBalance.toString(), zeroBN.toString());
    assert.equal(marketBalance.sub(lastMarketBalance).toString(), zeroBN.clone().add(tradeFee).toString());

    const totalSaleCount = await hmarket.totalSaleTokens();
    assert.equal(lastTotalSaleCount.sub(totalSaleCount).toString(), zeroBN.clone().add(oneBN).toString());
  });
  it("Market balance withdraw", async () => {
    const lastBalance3 = await token.balanceOf(acc3);
    const lastMarketBalance = await token.balanceOf(hmarket.address);

    assert.notEqual(lastMarketBalance, zeroBN);

    await hmarket.withdrawBalance(acc3, lastMarketBalance);

    const balance3 = await token.balanceOf(acc3);
    assert.equal(balance3.sub(lastBalance3).toString(), zeroBN.clone().add(lastMarketBalance).toString());

    const marketBalance = await token.balanceOf(hmarket.address);
    assert.equal(marketBalance.toString(), zeroBN.toString());
  })
});
