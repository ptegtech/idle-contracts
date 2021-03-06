const WETHToken = artifacts.require("WETHToken");

contract("test WETHToken", async accounts => {
  let token;
  const acc0 = accounts[0];
  const acc1 = accounts[1];
  const acc2 = accounts[2];
  const acc3 = accounts[3];
  const zeroBN = new web3.utils.BN(0);
  let catchRevertAccessControl = require("./exceptions.js").catchRevertAccessControl;
  before(async function() {
    token = await WETHToken.deployed();
  });
  it("should mint token to the second account 1", async () => {
    const amount = 10000;
    const amountBN = new web3.utils.BN(amount);
    const mintAmount = web3.utils.toWei(amountBN, "ether");

    let balance = await token.balanceOf(acc1);
    assert.equal(balance.toString(), zeroBN.toString());
    await token.safeMint(acc1, mintAmount, {from: acc0});
    balance = await token.balanceOf(acc1);
    assert.equal(balance.toString(), mintAmount.toString());
  });
  it("should transfer ether to the account 2", async () => {
    const amount = 10;
    const amountBN = new web3.utils.BN(amount);
    const transAmount = web3.utils.toWei(amountBN, "ether");

    const lastBalance1 = await token.balanceOf(acc1);
    const lastBalance2 = await token.balanceOf(acc2);
    assert.equal(lastBalance2.toString(), zeroBN.toString());

    await token.transfer(acc2, transAmount, {from: acc1});
    const balance1 = await token.balanceOf(acc1);
    assert.equal(lastBalance1.sub(balance1).toString(), transAmount.toString());

    const balance2 = await token.balanceOf(acc2);
    assert.equal(balance2.toString(), transAmount.toString());
  });
  it("should transfer ether to the account 3 with approve", async () => {
    const amount = 10;
    const amountBN = new web3.utils.BN(amount);
    const transAmount = web3.utils.toWei(amountBN, "ether");

    const lastBalance1 = await token.balanceOf(acc1);
    const lastBalance3 = await token.balanceOf(acc3);
    assert.equal(lastBalance3.toString(), zeroBN.toString());

    await token.approve(acc3, transAmount, {from: acc1});
    const allowance = await token.allowance(acc1, acc3);
    assert.equal(allowance.toString(), transAmount.toString());

    await token.transferFrom(acc1, acc3, transAmount, {from: acc3});
    const balance1 = await token.balanceOf(acc1);
    assert.equal(lastBalance1.sub(balance1).toString(), transAmount.toString());

    const balance3 = await token.balanceOf(acc3);
    assert.equal(balance3.toString(), transAmount.toString());
  });
  it("mint token with account 1 should abort with an error", async function() {
    const amount = 10000;
    const amountBN = new web3.utils.BN(amount);
    const mintAmount = web3.utils.toWei(amountBN, "ether");
    await catchRevertAccessControl(token.safeMint(acc1, mintAmount, {from: acc1}));
  })
});
