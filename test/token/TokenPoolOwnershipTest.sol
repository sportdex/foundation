pragma solidity ^0.4.18;

import "truffle/Assert.sol";
import "truffle/DeployedAddresses.sol";
import "../../contracts/token/SportDexToken.sol";
import "../../contracts/token/TokenPool.sol";
import "./TestUtils.sol";

contract TokenPoolOwnershipTest is TokenPoolTestBase {
  function testOwnership() public {
    var token = new SportDexToken();
    var pool = createPool(token, 100);
    var proxy = new TokenPoolProxy(pool);
    Assert.equal(proxy.getBalance(), 100, "Incorrect balance");
    Assert.isFalse(proxy.call("batchDeposit", userAddresses, amounts), "Should fail");
    Assert.isFalse(proxy.call("drain"), "Should fail");
  }
}
