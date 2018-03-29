const SportDexToken = artifacts.require("./token/SportDexToken.sol");
const BankPool = artifacts.require("./token/BankPool.sol");

async function deploy(deployer) {
  const token = await SportDexToken.deployed();
  deployer.deploy(BankPool, token.address);
}

module.exports = deploy;
