const WETHToken = artifacts.require("WETHToken");
const IdleKey = artifacts.require("IdleKey");
const KeyMarket = artifacts.require("KeyMarket");
const HeroBox = artifacts.require("HeroBox");
const IdleHero = artifacts.require("IdleHero");
const HeroBorn = artifacts.require("HeroBorn");
const IdleRNG = artifacts.require("IdleRNG");
const StoneToken = artifacts.require("StoneToken");


contract("test bornhero", async accounts => {
    let token;
    let key;
    let kmarket;
    let box;
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
      born = await HeroBorn.deployed();
      rng = await IdleRNG.deployed();
      stone = await StoneToken.deployed();
    });
    it("should born new nft with 2 nfts with owenr account", async () => {
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

        await key.isApprovedForAll(acc0, box.address);
        await key.setApprovalForAll(box.address, true, { from: acc0 });

        const seed = 12345689;
        const seedBN = new web3.utils.BN(seed);
        await rng.setRandomSeed(acc0, seedBN);
        await rng.isSeedReady(acc0);

        await box.openBox(acc0, { from: acc0 });
        await box.openBox(acc0, { from: acc0 });
        let addr_temp = await hero.ownerOf(1);
        assert.equal(addr_temp, acc0);

        await stone.safeMint(acc0, mintAmount, {from: acc0});
        await stone.approve(born.address, web3.utils.toWei('1000', 'ether'), { from: acc0 });

        await born.bornHero(1,2);
        let addr_temp2 = await hero.ownerOf(3);
        assert.equal(addr_temp2, acc0);
    });
    it("should born new nft with 2 nfts with owenr account 1", async () => {
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

      const seed = 12345688;
      const seedBN = new web3.utils.BN(seed);
      await rng.setRandomSeed(acc1, seedBN);
      await rng.isSeedReady(acc1);

      await box.openBox(acc1, { from: acc1 });
      await box.openBox(acc1, { from: acc1 });
      var addr_temp = await hero.ownerOf(4);
      assert.equal(addr_temp, acc1);
      addr_temp = await hero.ownerOf(5);
      assert.equal(addr_temp, acc1);

      await stone.safeMint(acc1, mintAmount, {from: acc1});
      await stone.approve(born.address, web3.utils.toWei('1000', 'ether'), { from: acc1 });

      await born.bornHero(4,5, { from: acc1 });
      let addr_temp2 = await hero.ownerOf(6);
      assert.equal(addr_temp2, acc1);
  });
  });