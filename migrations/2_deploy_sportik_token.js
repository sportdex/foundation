const SportikToken = artifacts.require("./token/SportikToken.sol");

function deploy(deployer) {
  deployer.deploy(SportikToken);
}

module.exports = deploy;
