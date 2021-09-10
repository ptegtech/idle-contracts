// migrations/2_deploy_upgradeable.js
const WETHToken = artifacts.require('WETHToken');

module.exports = async function (deployer) {
  await deployer.deploy(WETHToken, web3.utils.toWei('1000000', 'ether'));

  const weth = await WETHToken.deployed();
  
  console.log('Deployed WETHToken', weth.address);
};