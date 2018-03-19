pragma solidity ^0.4.18;

import "zeppelin-solidity/contracts/token/ERC20/StandardToken.sol";

contract DelegatableToken is StandardToken {
  event DelegatedTransfer(address indexed delegate, address indexed from, address indexed to, uint256 amount);
  event DelegatedApprove(address indexed delegate, address indexed owner, address indexed spender, uint256 amount);

  mapping (bytes32 => bool) delegatedTxns;

  function delegatedTransfer(
    address from,
    address to,
    uint256 value,
    uint256 nonce,
    uint8 v, bytes32 r, bytes32 s
  ) public returns (bool) {
    address delegate = msg.sender;
    address token = address(this);

    require(from != address(0));
		require(to != address(0));
    require(value <= balances[from]);

    // 0x1b208786: delegatedTransfer(address,address,uint256,uint256)
    bytes32 hash = keccak256(delegate, token, bytes4(0x1b208786), from, to, value, nonce);
    require(delegatedTxns[hash] != true);
    require(ecrecover(hash, v, r, s) == from);

    balances[from] = balances[from].sub(value);
    balances[to] = balances[to].add(value);
    delegatedTxns[hash] = true;
    DelegatedTransfer(delegate, from, to, value);
    return true;
  }

  function delegatedApprove(
    address owner,
    address spender,
    uint256 value,
    uint256 nonce,
    uint8 v, bytes32 r, bytes32 s
  ) public returns (bool) {
    address delegate = msg.sender;
    address token = address(this);

    require(owner != address(0));
		require(spender != address(0));
    require(value <= balances[owner]);

    // 0xfe7d02f7: delegatedApprove(address,address,uint256,uint256)
    bytes32 hash = keccak256(delegate, token, bytes4(0xfe7d02f7), owner, spender, value, nonce);
    require(delegatedTxns[hash] != true);
    require(ecrecover(hash, v, r, s) == owner);

    allowed[owner][spender] = value;
    delegatedTxns[hash] = true;
    DelegatedApprove(delegate, owner, spender, value);
    return true;
  }
}
