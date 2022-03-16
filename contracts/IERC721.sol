//SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.4;

interface IERC721 {
    function balanceOf(address owner) external view returns (uint256 balance);
}
