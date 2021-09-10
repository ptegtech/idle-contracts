// migrations/2_deploy_upgradeable.js
const ChildIdleHero = artifacts.require('ChildIdleHero');
const HeroMarket = artifacts.require('HeroMarket');
const WETHToken = artifacts.require('WETHToken');

module.exports = async function (deployer) {
  await deployer.deploy(HeroMarket);

  const hmarket = await HeroMarket.deployed();
  const hero = await ChildIdleHero.deployed();
  const weth = await WETHToken.deployed();

  hmarket.setHeroContract(hero.address);
  hmarket.setToken20Contract(weth.address);

  console.log('Deployed HeroMarket', hmarket.address);
};