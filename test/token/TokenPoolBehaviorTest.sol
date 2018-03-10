pragma solidity ^0.4.18;

import "truffle/Assert.sol";
import "truffle/DeployedAddresses.sol";
import "../../contracts/token/SportikToken.sol";
import "../../contracts/token/TokenPool.sol";
import "./TestUtils.sol";

contract TokenPoolBehaviorTest is TokenPoolTestBase {
  function testGetBalance() public {
    uint amount = 100000;
    var token = new SportikToken();
    var pool = createPool(token, amount);
    Assert.equal(pool.getBalance(), amount, "Incorrect balance");
    Assert.equal(token.balanceOf(address(pool)), amount, "Incorrect balance");
  }

  function testBatchDeposit() public {
    var token = new SportikToken();
    var pool = createPool(token, 0);
    for (uint i = 0; i < users.length; i++) {
      token.transfer(users[i], amounts[i] * 2);
      users[i].setToken(token);
      users[i].approve(address(pool), amounts[i]);
      Assert.equal(token.allowance(userAddresses[i], address(pool)), amounts[i], "asdf");
    }
    pool.batchDeposit(userAddresses, amounts);
    Assert.equal(pool.getBalance(), 15, "Incorrect deposit sum");
  }

  function testBatchDepositWithoutApproval() public {
    var token = new SportikToken();
    var pool = createPool(token, 0);
    Assert.isFalse(pool.call("batchDeposit", userAddresses, amounts), "Should fail");
  }

  function testBatchWithdraw() public {
    var token = new SportikToken();
    var pool = createPool(token, 15);
    pool.batchWithdraw(userAddresses, amounts);
    Assert.equal(pool.getBalance(), 0, "Incorrect balance after withdraw");
    for (uint i = 0; i < users.length; i++) {
      Assert.equal(token.balanceOf(userAddresses[i]), amounts[i], "Incorrect withdrew balance");
    }
  }

  function testBatchWithdrawWithoutSuffcientFund() public {
    var token = new SportikToken();
    var pool = createPool(token, 10);
    Assert.isFalse(pool.call("batchWithdraw", userAddresses, amounts), "Should fail");
  }

  function testDrain() public {
    var token = new SportikToken();
    var pool = createPool(token, 115);
    pool.batchWithdraw(userAddresses, amounts);
    Assert.equal(pool.getBalance(), 100, "Incorrect balance after withdraw");
    for (uint i = 0; i < users.length; i++) {
      Assert.equal(token.balanceOf(userAddresses[i]), amounts[i], "Incorrect withdrew balance");
    }
    pool.drain();
    Assert.equal(pool.getBalance(), 0, "Pool should be empty");
    Assert.equal(token.balanceOf(address(this)), token.totalSupply() - 15, "Pool should be empty");
  }
}
