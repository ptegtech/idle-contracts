// migrations/2_deploy_upgradeable.js
const IdleHero = artifacts.require('IdleHero');
const HeroBorn = artifacts.require('HeroBorn');
const HeroGene = artifacts.require('HeroGene');
const IdleRNG = artifacts.require('IdleRNG');
const StoneToken = artifacts.require('StoneToken');
const HeroGeneShowSkill = artifacts.require('HeroGeneShowSkill');

module.exports = async function (deployer) {
  await deployer.deploy(HeroBorn);
  await deployer.deploy(HeroGene);
  await deployer.deploy(HeroGeneShowSkill);

  const hero = await IdleHero.deployed();
  const born = await HeroBorn.deployed();
  const stone = await StoneToken.deployed();
  const gene = await HeroGene.deployed();
  const geness = await HeroGeneShowSkill.deployed();
  const rng = await IdleRNG.deployed();

  await born.setHeroContract(hero.address);
  await born.setToken20Contract(stone.address);
  await born.setGeneContract(gene.address);
  await born.setRNGContract(rng.address);
  await gene.setRNGContract(rng.address);
  await hero.grantMinter(born.address);
  await gene.setHeroGeneShowSkillContract(geness.address);
  await geness.setRNGContract(rng.address);

  console.log('Deployed HeroBorn', born.address);
  console.log('Deployed HeroGene', gene.address);
  console.log('Deployed HeroGeneShowSkill', gene.address);
};