const StoneToken = artifacts.require("StoneToken");

contract("test StoneToken", async accounts => {
  let stone;
  const acc0 = accounts[0];
  const acc1 = accounts[1];
  const acc2 = accounts[2];
  const acc3 = accounts[3];
  const zeroBN = new web3.utils.BN(0);
  before(async function() {
    stone = await StoneToken.deployed();
  });
  it("should mint token to the second account 1", async () => {
    const amount = 10000;
    const amountBN = new web3.utils.BN(amount);
    const mintAmount = web3.utils.toWei(amountBN, "ether");

    let balance = await stone.balanceOf(acc1);
    assert.equal(balance.toString(), zeroBN.toString());
    await stone.safeMint(acc1, mintAmount, {from: acc0});
    balance = await stone.balanceOf(acc1);
    assert.equal(balance.toString(), mintAmount.toString());
  });
  it("should transfer ether to the account 2", async () => {
    const amount = 10;
    const amountBN = new web3.utils.BN(amount);
    const transAmount = web3.utils.toWei(amountBN, "ether");

    const lastBalance1 = await stone.balanceOf(acc1);
    const lastBalance2 = await stone.balanceOf(acc2);
    assert.equal(lastBalance2.toString(), zeroBN.toString());

    await stone.transfer(acc2, transAmount, {from: acc1});
    const balance1 = await stone.balanceOf(acc1);
    assert.equal(lastBalance1.sub(balance1).toString(), transAmount.toString());

    const balance2 = await stone.balanceOf(acc2);
    assert.equal(balance2.toString(), transAmount.toString());
  });
  it("should transfer ether to the account 3 with approve", async () => {
    const amount = 10;
    const amountBN = new web3.utils.BN(amount);
    const transAmount = web3.utils.toWei(amountBN, "ether");

    const lastBalance1 = await stone.balanceOf(acc1);
    const lastBalance3 = await stone.balanceOf(acc3);
    assert.equal(lastBalance3.toString(), zeroBN.toString());

    await stone.approve(acc3, transAmount, {from: acc1});
    const allowance = await stone.allowance(acc1, acc3);
    assert.equal(allowance.toString(), transAmount.toString());

    await stone.transferFrom(acc1, acc3, transAmount, {from: acc3});
    const balance1 = await stone.balanceOf(acc1);
    assert.equal(lastBalance1.sub(balance1).toString(), transAmount.toString());

    const balance3 = await stone.balanceOf(acc3);
    assert.equal(balance3.toString(), transAmount.toString());
  });
});
