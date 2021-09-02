// migrations/2_deploy_upgradeable.js
const IdleHero = artifacts.require('IdleHero');
const WETHToken = artifacts.require('WETHToken');
const HeroMarket = artifacts.require('HeroMarket');

module.exports = async function (deployer) {
  await deployer.deploy(HeroMarket);

  const hmarket = await HeroMarket.deployed();
  const weth = await WETHToken.deployed();
  const hero = await IdleHero.deployed();

  hmarket.setHeroContract(hero.address);
  hmarket.setToken20Contract(weth.address);

  console.log('Deployed HeroMarket', hmarket.address);
};