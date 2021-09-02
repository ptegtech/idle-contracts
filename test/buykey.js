const WETHToken = artifacts.require("WETHToken");
const IdleKey = artifacts.require("IdleKey");
const KeyMarket = artifacts.require("KeyMarket");


contract("test IIdleKey", async accounts => {
    let token;
    let key;
    let kmarket;
    const acc0 = accounts[0];
    const acc1 = accounts[1];
    const acc2 = accounts[2];
    const acc3 = accounts[3];
    const zeroBN = new web3.utils.BN(0);
    const keyPrice = new web3.utils.BN(1);
    const keyPriceBN = web3.utils.toWei(keyPrice, "ether");
    before(async function() {
      token = await WETHToken.deployed();
      key = await IdleKey.deployed();
      kmarket = await KeyMarket.deployed();
    });
    it("should buy key to account 0", async () => {
      const amount = 10000;
      const amountBN = new web3.utils.BN(amount);
      const mintAmount = web3.utils.toWei(amountBN, "ether");
  
      let balance = await token.balanceOf(acc0);
      await token.safeMint(acc0, mintAmount, {from: acc0});
      
      await kmarket.setKeyPrice(keyPriceBN);
      await token.approve(kmarket.address, web3.utils.toWei("10", "ether"), {from: acc0});

      const lastMarketBalance = await token.balanceOf(kmarket.address);
      
      await kmarket.buyKey({from: acc0});
      let addr = await key.ownerOf(1);
      assert.equal(addr, acc0);

      let marketBalance = await token.balanceOf(kmarket.address);
      assert.notEqual(marketBalance.toString(), zeroBN.toString());
      assert.equal(marketBalance.sub(lastMarketBalance).toString(), zeroBN.clone().add(keyPriceBN).toString());
    });
    it("Market balance withdraw", async () => {
      const lastBalance3 = await token.balanceOf(acc3);
      const lastMarketBalance = await token.balanceOf(kmarket.address);
  
      assert.notEqual(lastMarketBalance, zeroBN);
  
      await kmarket.withdrawBalance(acc3, lastMarketBalance);
  
      const balance3 = await token.balanceOf(acc3);
      assert.equal(balance3.sub(lastBalance3).toString(), zeroBN.clone().add(lastMarketBalance).toString());
  
      const marketBalance = await token.balanceOf(kmarket.address);
      assert.equal(marketBalance.toString(), zeroBN.toString());
    });
    it("should buy key to account 1", async () => {
      const amount = 10000;
      const amountBN = new web3.utils.BN(amount);
      const mintAmount = web3.utils.toWei(amountBN, "ether");
  
      let balance = await token.balanceOf(acc1);
      await token.safeMint(acc1, mintAmount, {from: acc1});
      
      await kmarket.setKeyPrice(web3.utils.toWei("0.001", "ether"));
      await token.approve(kmarket.address, web3.utils.toWei("10", "ether"), {from: acc1});
      
      await kmarket.buyKey({from: acc1});
      let addr = await key.ownerOf(2);
      assert.equal(addr, acc1);
    });
  });