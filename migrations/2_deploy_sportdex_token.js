const SportDexToken = artifacts.require("./token/SportDexToken.sol");

function deploy(deployer) {
  deployer.deploy(SportDexToken);
}

module.exports = deploy;
