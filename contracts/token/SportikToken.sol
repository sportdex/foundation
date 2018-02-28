pragma solidity ^0.4.18;

import "zeppelin-solidity/contracts/token/ERC20/PausableToken.sol";

/**
 * @title Sportik Token
 * @dev ERC20-compatible Sportik Token
 */
contract SportikToken is PausableToken {
  bytes32 public constant name = "SportikToken";
  bytes32 public constant symbol= "SPORT";
  uint8 public constant decimals = 18;
  uint256 public constant initial_supply = 1e9;

  function SportikToken() public {
    var supplyInInteger = initial_supply * 10 ** uint256(decimals);
    totalSupply_ = supplyInInteger;
    balances[msg.sender] = supplyInInteger;
  }
}
