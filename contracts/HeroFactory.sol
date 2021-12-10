// SPDX-License-Identifier: MIT

pragma solidity ^0.8.10;

import './Ownable.sol';
import './SafeMath.sol';

contract HeroFactory is Ownable {
  using SafeMath for uint256;
  using SafeMath32 for uint32;
  using SafeMath16 for uint16;

  uint256 dnaDigits = 16;
  uint256 dnaModulus = 10**dnaDigits;
  uint256 cooldownTime = 1 days;

  event NewHero(uint256 heroId, string name, uint256 dna);

  struct Hero {
    string name;
    uint256 dna;
    uint32 level;
  }

  Hero[] public heroes;

  mapping(uint256 => address) public heroToOwner;
  mapping(address => uint256) ownerHeroCount;

  function _generateRandomDna(string memory _str) private view returns (uint256) {
    uint256 rand = uint256(keccak256(abi.encodePacked(_str)));
    return rand % dnaModulus;
  }

  function _createHero(string memory _name, uint256 _dna) internal {
    heroes.push(Hero(_name, _dna, 1));
    uint256 id = heroes.length - 1;
    heroToOwner[id] = msg.sender;
    ownerHeroCount[msg.sender] = ownerHeroCount[msg.sender].add(1);
    emit NewHero(id, _name, _dna);
  }

  function createRandomHero(string memory _name) public {
    // require(ownerHeroCount[msg.sender] == 0); // User can have only one random hero
    uint256 randDna = _generateRandomDna(_name);
    _createHero(_name, randDna);
  }
}
