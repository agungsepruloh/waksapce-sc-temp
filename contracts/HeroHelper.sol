// SPDX-License-Identifier: MIT

pragma solidity ^0.8.10;

import './SafeMath.sol';
import './HeroFactory.sol';

contract HeroHelper is HeroFactory {
  function getHeroesByOwner(address _owner) external view returns (uint256[] memory) {
    uint256[] memory result = new uint256[](ownerHeroCount[_owner]);
    uint256 counter = 0;
    for (uint256 i = 0; i < heroes.length; i++) {
      if (heroToOwner[i] == _owner) {
        result[counter] = i;
        counter++;
      }
    }
    return result;
  }
}
