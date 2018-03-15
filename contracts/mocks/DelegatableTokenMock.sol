pragma solidity ^0.4.18;

import "../token/DelegatableToken.sol";

contract DelegatableTokenMock is DelegatableToken {
  function DelegatableTokenMock(uint256 supply) public {
    totalSupply_ = supply;
    balances[msg.sender] = supply;
  }
}
