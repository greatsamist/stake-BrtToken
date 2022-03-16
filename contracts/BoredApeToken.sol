//SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.4;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract BoredToken is ERC20, Ownable {
    constructor() ERC20("BoredToken", "BRT") {
        // automatically mint 100 tokens to msg.sender
        _mint(msg.sender, 100 * 10**18);
    }

    // Mints amount of BoredToken
    function mint(uint256 amount) public payable {
        uint256 amountWithDecimals = amount * 10**18;
        _mint(msg.sender, amountWithDecimals);
    }
}
