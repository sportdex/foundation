pragma solidity ^0.4.18;

import "truffle/Assert.sol";
import "truffle/DeployedAddresses.sol";
import "../../contracts/token/SportikToken.sol";
import "../../contracts/token/TokenPool.sol";
import "./TestUtils.sol";

contract TokenPoolBatchTest is TokenPoolTestBase {
  function testBatchDeposit() public {
    var token = new SportikToken();
    var pool = createPool(token, 0);
    for (uint i = 0; i < users.length; i++) {
      token.transfer(users[i], amounts[i] * 2);
      users[i].setToken(token);
      users[i].approve(address(pool), amounts[i] * 2);
      Assert.equal(token.allowance(userAddresses[i], address(pool)), amounts[i] * 2, "Incorrect allowance");
    }
    pool.batchDeposit(0, userAddresses, amounts);
    Assert.equal(pool.getBalance(), 15, "Incorrect deposit sum");
    pool.batchDeposit(0, userAddresses, amounts);
    Assert.equal(pool.getBalance(), 15, "Incorrect deposit sum");
    pool.batchDeposit(1, userAddresses, amounts);
    Assert.equal(pool.getBalance(), 30, "Incorrect deposit sum");
  }

  function testBatchDepositWithoutApproval() public {
    var token = new SportikToken();
    var pool = createPool(token, 0);
    Assert.isFalse(pool.call("batchDeposit", 0, userAddresses, amounts), "Should fail");
  }

  function testBatchWithdraw() public {
    var token = new SportikToken();
    var pool = createPool(token, 30);
    pool.batchWithdraw(0, userAddresses, amounts);
    Assert.equal(pool.getBalance(), 15, "Incorrect balance after withdraw");
    for (uint i = 0; i < users.length; i++) {
      Assert.equal(token.balanceOf(userAddresses[i]), amounts[i], "Incorrect withdrew balance");
    }
    pool.batchWithdraw(0, userAddresses, amounts);
    Assert.equal(pool.getBalance(), 15, "Incorrect balance after withdraw");
    pool.batchWithdraw(1, userAddresses, amounts);
    Assert.equal(pool.getBalance(), 0, "Incorrect balance after withdraw");
  }

  function testBatchWithdrawWithoutSuffcientFund() public {
    var token = new SportikToken();
    var pool = createPool(token, 10);
    Assert.isFalse(pool.call("batchWithdraw", 0, userAddresses, amounts), "Should fail");
  }
}
