// migrations/2_deploy_upgradeable.js
const StoneToken = artifacts.require('StoneToken');
const WETHToken = artifacts.require('WETHToken');

module.exports = async function (deployer) {
  await deployer.deploy(StoneToken, web3.utils.toWei('1000000', 'ether'));
  await deployer.deploy(WETHToken, web3.utils.toWei('1000000', 'ether'));

  const weth = await WETHToken.deployed();
  const token = await StoneToken.deployed();
  
  console.log('Deployed WETHToken', weth.address);
  console.log('Deployed StoneToken', token.address);
};