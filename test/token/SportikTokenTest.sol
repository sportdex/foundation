pragma solidity ^0.4.18;

import "truffle/Assert.sol";
import "truffle/DeployedAddresses.sol";
import "../../contracts/token/SportikToken.sol";

contract TokenUser {
  function approve(SportikToken token, address delegate, uint amount) public returns (bool) {
    return token.approve(delegate, amount);
  }

  function transferFrom(SportikToken token, address from, address to, uint amount) public returns (bool) {
    return token.transferFrom(from, to, amount);
  }
}

contract SportikTokenTest {
  function testTokenBasic() public {
    SportikToken token = SportikToken(DeployedAddresses.SportikToken());
    Assert.equal(token.NAME(), "SportikToken", "Incorrect token name");
    Assert.equal(token.SYMBOL(), "SPORT", "Incorrect token symbol");
    Assert.equal(token.DECIMALS(), uint256(18), "Incorrect decimals");
    Assert.equal(token.balanceOf(token.owner()), 1e27, "Incorrect total supply");
  }

  function testTransfer() public {
    address owner = address(this);
    address addr = 0x1;
    SportikToken token = new SportikToken();
    token.transfer(addr, uint(1));
    Assert.equal(token.balanceOf(addr), uint(1), "Incorrect balance");
    Assert.equal(token.balanceOf(owner), uint(1e27 - 1), "Incorrect balance");
  }

  function testApprove() public {
    address owner = address(this);
    address addr = 0x1;
    uint amount = 1000;
    SportikToken token = new SportikToken();
    Assert.isTrue(token.approve(addr, amount), "Fail to approve");
    Assert.equal(token.allowance(owner, addr), amount, "Incorrect allowance");
  }

  function testTransferFrom() public {
    uint amount = 1000;
    uint spent = 100;
    TokenUser user1 = new TokenUser();
    TokenUser user2 = new TokenUser();
    SportikToken token = new SportikToken();
    token.transfer(address(user1), amount);
    user1.approve(token, address(user2), amount);
    Assert.equal(token.allowance(address(user1), address(user2)), amount, "Fail to approve");
    user2.transferFrom(token, address(user1), address(user2), spent);
    Assert.equal(token.balanceOf(address(user1)), amount - spent, "Incorrect balance");
    Assert.equal(token.balanceOf(address(user2)), spent, "Incorrect balance");
    Assert.equal(token.balanceOf(address(this)), 1e27 - amount, "Incorrect balance");
  }

  function testPause() public {
    address addr = 0x1;
    uint amount = 1000;
    SportikToken token = new SportikToken();
    token.transfer(addr, amount);
    token.pause();
    bool shouldFail = address(token).call("transfer", addr, amount);
    Assert.isFalse(shouldFail, "Should fail to transfer");
    token.unpause();
    token.transfer(addr, amount);
    Assert.equal(token.balanceOf(addr), 2000, "Incorrect balance");
  }
}
