const SportDexToken = artifacts.require("./token/SportDexToken.sol");
const AirdropPool = artifacts.require("./token/AirdropPool.sol");

async function deploy(deployer) {
  const token = await SportDexToken.deployed();
  deployer.deploy(AirdropPool, token.address);
}

module.exports = deploy;
