const SportDexToken = artifacts.require("./token/SportDexToken.sol");
const TokenPool = artifacts.require("./token/TokenPool.sol");

async function deploy(deployer) {
  const token = await SportDexToken.deployed();
  deployer.deploy(TokenPool, token.address);
}

module.exports = deploy;
