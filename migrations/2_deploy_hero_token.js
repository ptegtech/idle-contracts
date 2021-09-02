// migrations/2_deploy_upgradeable.js
const IdleHero = artifacts.require('IdleHero');
const IdleKey = artifacts.require('IdleKey');

module.exports = async function (deployer) {
  await deployer.deploy(IdleHero);
  await deployer.deploy(IdleKey);

  const hero = await IdleHero.deployed();
  const key = await IdleKey.deployed();
  
  console.log('Deployed IdleHero', hero.address);
  console.log('Deployed IdleKey', key.address);
};