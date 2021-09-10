// migrations/2_deploy_upgradeable.js
const ChildIdleHero = artifacts.require('ChildIdleHero');
const HeroStorage = artifacts.require('HeroStorage');
const ChildIdleKey = artifacts.require('ChildIdleKey');

module.exports = async function (deployer) {
  await deployer.deploy(ChildIdleHero);
  await deployer.deploy(HeroStorage);
  await deployer.deploy(ChildIdleKey);

  const hero = await ChildIdleHero.deployed();
  const storage = await HeroStorage.deployed();
  const key = await ChildIdleKey.deployed();

  await hero.setHeroStorage(storage.address);
  await storage.grantMinter(hero.address);
  
  console.log('Deployed IdleHero', hero.address);
  console.log('Deployed IdleKey', key.address);
  console.log('Deployed HeroStorage', storage.address);
};