pragma solidity ^0.4.18;

import "zeppelin-solidity/contracts/token/ERC20/PausableToken.sol";
import "./DelegatableToken.sol";

/**
 * @title Sportdex Token
 * @dev ERC20-compatible Token for Sport Dex
 */
contract SportDexToken is PausableToken, DelegatableToken {
  bytes32 public constant name = "SportDex";
  bytes32 public constant symbol= "SPO";
  uint8 public constant decimals = 4;
  uint256 public constant initial_supply = 1e9;

  mapping (address => bool) public delegateWhitelist;

  function SportDexToken() public {
    uint256 total = initial_supply * 10 ** uint256(decimals);
    totalSupply_ = total;
    balances[msg.sender] = total;
  }

  function addDelegate(address delegate) onlyOwner public returns (bool) {
    delegateWhitelist[delegate] = true;
  }

  function removeDelegate(address delegate) onlyOwner public returns (bool) {
    delete delegateWhitelist[delegate];
  }

  function delegatedTransfer(
    address from,
    address to,
    uint256 value,
    uint256 nonce,
    uint8 v, bytes32 r, bytes32 s
  ) public returns (bool) {
    require(delegateWhitelist[msg.sender]);
    return super.delegatedTransfer(from, to, value, nonce, v, r, s);
  }

  function delegatedApprove(
    address owner,
    address spender,
    uint256 value,
    uint256 nonce,
    uint8 v, bytes32 r, bytes32 s
  ) public returns (bool) {
    require(delegateWhitelist[msg.sender]);
    return super.delegatedApprove(owner, spender, value, nonce, v, r, s);
  }
}
