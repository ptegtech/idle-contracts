// migrations/2_deploy_upgradeable.js
const IdleRNG = artifacts.require('IdleRNG');

module.exports = async function (deployer) {
  await deployer.deploy(IdleRNG);

  const rng = await IdleRNG.deployed();

  console.log('Deployed IdleRNG', rng.address);
};