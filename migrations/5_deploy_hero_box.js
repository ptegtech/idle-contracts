// migrations/2_deploy_upgradeable.js
const ChildIdleHero = artifacts.require('ChildIdleHero');
const ChildIdleKey = artifacts.require('ChildIdleKey');
const KeyMarket = artifacts.require('KeyMarket');
const HeroBox = artifacts.require('HeroBox');
const IdleRNG = artifacts.require('IdleRNG');
const WETHToken = artifacts.require('WETHToken');

module.exports = async function (deployer) {
  await deployer.deploy(KeyMarket);
  await deployer.deploy(HeroBox);

  const hero = await ChildIdleHero.deployed();
  const key = await ChildIdleKey.deployed();
  const kmarket = await KeyMarket.deployed();
  const box = await HeroBox.deployed();
  const rng = await IdleRNG.deployed();
  const weth = await WETHToken.deployed();

  await kmarket.setKeyContract(key.address);
  await kmarket.setToken20Contract(weth.address);
  await key.grantMinter(kmarket.address);
  await box.setHeroContract(hero.address);
  await box.setKeyContract(key.address);
  await box.setRNGContract(rng.address);
  await hero.grantMinter(box.address);
  await rng.grantMinter(box.address);

  console.log('Deployed KeyMarket', kmarket.address);
  console.log('Deployed HeroBox', box.address);
};