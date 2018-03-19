pragma solidity ^0.4.19;

import "zeppelin-solidity/contracts/ownership/Ownable.sol";
import "./SportDexToken.sol";

contract TokenPool is Ownable {
  SportDexToken public token;
  mapping (uint256 => bool) nonceUsed;

  function TokenPool(SportDexToken _token) public {
    token = _token;
  }

  function getBalance() view public returns (uint256) {
    return token.balanceOf(address(this));
  }

  function drain() onlyOwner external returns (bool) {
    return token.transfer(owner, token.balanceOf(address(this)));
  }

  function batchDeposit(uint256 nonce, address[] addrs, uint256[] amounts) onlyOwner public returns (bool) {
    require(addrs.length == amounts.length);
    if (nonceUsed[nonce] == true) {
      return true;
    }
    // This pool must have been approved for the transferFrom call
    for (uint i = 0; i < addrs.length; i++) {
      token.transferFrom(addrs[i], address(this), amounts[i]);
    }
    nonceUsed[nonce] = true;
    return true;
  }

  function batchDelegatedDeposit(uint256 nonce, address[] addrs, uint256[] amounts, uint8[] vs, bytes32[] rs, bytes32[] ss) public returns (bool) {
    require(amounts.length == addrs.length);
    require(vs.length == addrs.length);
    require(rs.length == addrs.length);
    require(ss.length == addrs.length);
    if (nonceUsed[nonce] == true) {
      return true;
    }
    for (uint i = 0; i < addrs.length; i++) {
      token.delegatedTransfer(addrs[i], address(this), amounts[i], nonce, vs[i], rs[i], ss[i]);
    }
    nonceUsed[nonce] = true;
    return true;
  }

  function batchWithdraw(uint256 nonce, address[] addrs, uint256[] amounts) onlyOwner public returns (bool) {
    require(addrs.length == amounts.length);
    if (nonceUsed[nonce] == true) {
      return true;
    }
    for (uint i = 0; i < addrs.length; i++) {
      token.transfer(addrs[i], amounts[i]);
    }
    nonceUsed[nonce] = true;
    return true;
  }
}
