pragma solidity ^0.4.18;

import "zeppelin-solidity/contracts/token/ERC20/PausableToken.sol";
import "./DelegatableToken.sol";

/**
 * @title Sportik Token
 * @dev ERC20-compatible Sportik Token
 */
contract SportikToken is PausableToken, DelegatableToken {
  bytes32 public constant name = "SportikToken";
  bytes32 public constant symbol= "SPORT";
  uint8 public constant decimals = 4;
  uint256 public constant initial_supply = 1e9;

  mapping (address => bool) delegateWhitelist;

  function SportikToken() public {
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

  function delegateTransfer(
    address from,
    address to,
    uint256 value,
    uint256 nonce,
    bytes sig
  ) public returns (bool) {
    require(delegateWhitelist[msg.sender] == true);
    super.delegateTransfer(from, to, value, nonce, sig);
  }
}
