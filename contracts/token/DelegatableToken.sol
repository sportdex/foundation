pragma solidity ^0.4.18;

import "zeppelin-solidity/contracts/token/ERC20/BasicToken.sol";
import "zeppelin-solidity/contracts/ECRecovery.sol";

contract DelegatableToken is BasicToken {
  event DelegatedTransfer(address indexed delegate, address indexed from, address indexed to, uint256 amount);
  mapping (bytes32 => bool) delegatedTxns;

  function delegateTransfer(
    address from,
    address to,
    uint256 value,
    uint256 nonce,
    bytes sig
  ) public returns (bool) {
    address delegate = msg.sender;
    address token = address(this);

    require(from != address(0));
		require(to != address(0));
    require(value <= balances[from]);

    bytes32 hash = keccak256(token, delegate, from, to, value, nonce);
    require(ECRecovery.recover(hash, sig) == from);
    require(delegatedTxns[hash] != true);

    balances[from] = balances[from].sub(value);
    balances[to] = balances[to].add(value);
    delegatedTxns[hash] = true;
    DelegatedTransfer(delegate, from, to, value);
    return true;
  }
}
