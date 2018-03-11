pragma solidity ^0.4.18;

import "zeppelin-solidity/contracts/token/ERC20/ERC20.sol";
import "../../contracts/token/SportikToken.sol";
import "../../contracts/token/TokenPool.sol";

contract TokenUser {
  ERC20 token;

  function setToken(ERC20 _token) public {
      token = _token;
  }

  function approve(address delegate, uint amount) public returns (bool) {
    return token.approve(delegate, amount);
  }

  function transferFrom(address from, address to, uint amount) public returns (bool) {
    return token.transferFrom(from, to, amount);
  }
}

contract TokenPoolProxy {
  TokenPool pool;

  function TokenPoolProxy(TokenPool _pool) public {
    pool = _pool;
  }

  function getBalance() view public returns (uint256) {
    return pool.getBalance();
  }

  function batchDeposit(uint256 batchId, address[] addrs, uint256[] amounts) public returns (bool) {
    return pool.batchDeposit(batchId, addrs, amounts);
  }

  function drain() public returns (bool) {
    return pool.drain();
  }
}

contract TokenPoolTestBase {
  TokenUser[] users;
  address[] userAddresses;
  uint256[] amounts;
  
  function TokenPoolTestBase() public {
    for (uint i = 0; i < 5; i++) {
      var user = new TokenUser();
      users.push(user);
      userAddresses.push(address(user));
      amounts.push(i + 1);
    }
  }

  function createPool(SportikToken token, uint initial) internal returns (TokenPool) {
    TokenPool pool = new TokenPool(token);
    token.transfer(address(pool), initial);
    return pool;
  }
}

contract TestUtils {}