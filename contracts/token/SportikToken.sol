pragma solidity ^0.4.18;

import "zeppelin-solidity/contracts/token/ERC20/PausableToken.sol";

/**
 * @title Sportik Token
 * @dev ERC20-compatible Sportik Token
 */
contract SportikToken is PausableToken {
  bytes32 public constant NAME = "SportikToken";
  bytes32 public constant SYMBOL = "SPORT";
  uint8 public constant DECIMALS = 18;
  uint256 public constant INITIAL_SUPPLY = 1e9;

  function SportikToken() public {
    var supplyInWei = INITIAL_SUPPLY * 10 ** uint256(DECIMALS);
    totalSupply_ = supplyInWei;
    balances[msg.sender] = supplyInWei;
  }
}
