const SportikToken = artifacts.require("./token/SportikToken.sol");
const TokenPool = artifacts.require("./token/TokenPool.sol");

async function deploy(deployer) {
  const token = await SportikToken.deployed();
  deployer.deploy(TokenPool, token.address);
}

module.exports = deploy;
