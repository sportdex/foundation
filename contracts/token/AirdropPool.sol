pragma solidity ^0.4.19;

import "./TokenPool.sol";

contract AirdropPool is TokenPool {
  function AirdropPool(SportDexToken _token) TokenPool(_token) public {}
}
