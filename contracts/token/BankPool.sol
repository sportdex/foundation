pragma solidity ^0.4.19;

import "./TokenPool.sol";

contract BankPool is TokenPool {
  function BankPool(SportDexToken _token) TokenPool(_token) public {}
}
