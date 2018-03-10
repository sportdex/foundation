pragma solidity ^0.4.19;

import "zeppelin-solidity/contracts/ownership/Ownable.sol";
import "zeppelin-solidity/contracts/token/ERC20/ERC20.sol";

contract TokenPool is Ownable {
  ERC20 public token;

  event Test(uint index);

  function TokenPool(ERC20 _token) public {
    token = _token;
  }

  function getBalance() view public returns (uint256) {
    return token.balanceOf(address(this));
  }

  function batchDeposit(address[] addrs, uint256[] amounts) onlyOwner public returns (bool) {
    require(addrs.length == amounts.length);
    // This pool must have been approved for the transferFrom call
    for (uint i = 0; i < addrs.length; i++) {
      // require(token.allowance(addrs[i], address(this)) >= amounts[i]);
      token.transferFrom(addrs[i], address(this), amounts[i]);
    }
    return true;
  }

  function batchWithdraw(address[] addrs, uint256[] amounts) onlyOwner public returns (bool) {
    require(addrs.length == amounts.length);
    for (uint i = 0; i < addrs.length; i++) {
      token.transfer(addrs[i], amounts[i]);
    }
    return true;
  }

  function drain() onlyOwner external returns (bool) {
    return token.transfer(owner, token.balanceOf(address(this)));
  }
}
