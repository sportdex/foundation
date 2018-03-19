pragma solidity ^0.4.18;

import "truffle/Assert.sol";
import "truffle/DeployedAddresses.sol";
import "../../contracts/token/SportDexToken.sol";
import "../../contracts/token/TokenPool.sol";
import "./TestUtils.sol";

contract TokenPoolBasicTest is TokenPoolTestBase {
  function testGetBalance() public {
    uint amount = 100000;
    var token = new SportDexToken();
    var pool = createPool(token, amount);
    Assert.equal(pool.getBalance(), amount, "Incorrect balance");
    Assert.equal(token.balanceOf(address(pool)), amount, "Incorrect balance");
  }

  function testDrain() public {
    var token = new SportDexToken();
    var pool = createPool(token, 115);
    pool.batchWithdraw(0, userAddresses, amounts);
    Assert.equal(pool.getBalance(), 100, "Incorrect balance after withdraw");
    for (uint i = 0; i < users.length; i++) {
      Assert.equal(token.balanceOf(userAddresses[i]), amounts[i], "Incorrect withdrew balance");
    }
    pool.drain();
    Assert.equal(pool.getBalance(), 0, "Pool should be empty");
    Assert.equal(token.balanceOf(address(this)), token.totalSupply() - 15, "Pool should be empty");
  }
}
