const WETHToken = artifacts.require("WETHToken");
const IdleKey = artifacts.require("IdleKey");
const KeyMarket = artifacts.require("KeyMarket");
const HeroBox = artifacts.require("HeroBox");
const IdleHero = artifacts.require("IdleHero");
const IdleRNG = artifacts.require("IdleRNG");


contract("test openbox", async accounts => {
    let token;
    let key;
    let kmarket;
    let box;
    let hero;
    let rng;
    const acc0 = accounts[0];
    const acc1 = accounts[1];
    const acc2 = accounts[2];
    const acc3 = accounts[3];
    const zeroBN = new web3.utils.BN(0);
    before(async function() {
      token = await WETHToken.deployed();
      key = await IdleKey.deployed();
      kmarket = await KeyMarket.deployed();
      box = await HeroBox.deployed();
      hero = await IdleHero.deployed();
      rng = await IdleRNG.deployed();
    });
    it("should open box and save nft to account 0", async () => {
        const amount = 10000;
        const amountBN = new web3.utils.BN(amount);
        const mintAmount = web3.utils.toWei(amountBN, "ether");
    
        let balance = await token.balanceOf(acc0);
        await token.safeMint(acc0, mintAmount, {from: acc0});
        
        await kmarket.setKeyPrice(web3.utils.toWei("0.001", "ether"));
        await token.approve(kmarket.address, web3.utils.toWei("10", "ether"), {from: acc0});
        
        await kmarket.buyKey({from: acc0});
        await kmarket.buyKey({from: acc0});
        let addr = await key.ownerOf(1);
        assert.equal(addr, acc0);

        await key.setApprovalForAll(box.address, true, { from: acc0 });
        var isApproved = await key.isApprovedForAll(acc0, box.address);
        assert.equal(isApproved, true);

        const seed = 12345689;
        var seedBN = new web3.utils.BN(seed);
        await rng.setRandomSeed(acc0, seedBN);
        let seedReady = await rng.isSeedReady(acc0);
        assert.equal(seedReady, true);
        
        await box.openBox(acc0, { from: acc0 });
        let isOwenr = await hero.checkOwenr(acc0, 1);
        assert.equal(isOwenr, true);
    });
    it("should open box and save nft to account 1", async () => {
      const amount = 10000;
      const amountBN = new web3.utils.BN(amount);
      const mintAmount = web3.utils.toWei(amountBN, "ether");
  
      let balance = await token.balanceOf(acc1);
      await token.safeMint(acc1, mintAmount, {from: acc1});
      
      await kmarket.setKeyPrice(web3.utils.toWei("0.001", "ether"));
      await token.approve(kmarket.address, web3.utils.toWei("10", "ether"), {from: acc1});
      
      await kmarket.buyKey({from: acc1});
      await kmarket.buyKey({from: acc1});
      let addr = await key.ownerOf(3);
      assert.equal(addr, acc1);

      await key.setApprovalForAll(box.address, true, { from: acc1 });
      var isApproved = await key.isApprovedForAll(acc1, box.address);
      assert.equal(isApproved, true);

      const seed = 123456890;
      var seedBN = new web3.utils.BN(seed);
      await rng.setRandomSeed(acc1, seedBN);
      let seedReady = await rng.isSeedReady(acc1);
      assert.equal(seedReady, true);
      
      await box.openBox(acc1, { from: acc1 });
      let isOwenr = await hero.checkOwenr(acc1, 2);
      assert.equal(isOwenr, true);
  });
  });