// SPDX-License-Identifier: MIT

pragma solidity ^0.8.10;

import './ERC721.sol';
import './SafeMath.sol';
import './HeroHelper.sol';

/// @title A contract that manages transfering zombie ownership
/// @author Agung Sepruloh
/// @dev Development
abstract contract HeroOwnership is HeroHelper, ERC721 {
  using SafeMath for uint256;
  using SafeMath32 for uint32;
  using SafeMath16 for uint16;

  mapping(uint256 => address) heroApprovals;

  function balanceOf(address _owner) external view override returns (uint256) {
    return ownerHeroCount[_owner];
  }

  function ownerOf(uint256 _tokenId) external view virtual override returns (address) {
    return heroToOwner[_tokenId];
  }

  function _transfer(
    address _from,
    address _to,
    uint256 _tokenId
  ) private {
    ownerHeroCount[_to] = ownerHeroCount[_to].add(1);
    ownerHeroCount[_from] = ownerHeroCount[_from].sub(1);
    heroToOwner[_tokenId] = _to;
    emit Transfer(_from, _to, _tokenId);
  }

  function transferFrom(
    address _from,
    address _to,
    uint256 _tokenId
  ) external payable override {
    require(heroToOwner[_tokenId] == msg.sender || heroApprovals[_tokenId] == msg.sender);
    _transfer(_from, _to, _tokenId);
  }

  function approve(address _approved, uint256 _tokenId) external payable override onlyOwnerOf(_tokenId) {
    heroApprovals[_tokenId] = _approved;
    emit Approval(msg.sender, _approved, _tokenId);
  }

  modifier onlyOwnerOf(uint256 _heroId) {
    require(msg.sender == heroToOwner[_heroId]);
    _;
  }
}
