const Migrations = artifacts.require("./Migrations.sol");

function deploy(deployer) {
  deployer.deploy(Migrations);
}

export default deploy;
