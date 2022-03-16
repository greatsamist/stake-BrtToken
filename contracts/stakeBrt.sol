/*  
Write  a staking contract that accepts an erc20 token called boredApeToken(created by you,18 decimasls)

- When people stake brt, they 10% of it per month provided they have staked for 3 days or more
- IMPORTANT: Only BoredApes owners can use your contract

BOREDAPES NFT: 0xbc4ca0eda7647a8ab7c2061c2e118a18a936f13d
*/

//SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.4;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/token/ERC721/ERC721.sol";

contract stakingBrt {
    IERC20 stakingToken;
    IERC721 BoredApesNFT;

    mapping(address => uint256) bal;
    mapping(address => uint256) stakeTime;
    mapping(address => uint256) stakePeriod;

    constructor(address _stakingToken, address _BoredApesNFT) {
        stakingToken = IERC20(_stakingToken);
        BoredApesNFT = IERC721(_BoredApesNFT);
    }

    function stakeToken(uint256 _amountToken) public returns (bool sucess) {
        require(_amountToken > 0, "Cannot stake 0");
        // A require statement that the address is inside the BoredNFT
        uint256 balance = BoredApesNFT.balanceOf(msg.sender);
        require(balance > 0, "You don't own BoredApes NFT's");

        // Setting the time
        stakeTime[msg.sender] = block.timestamp;
        stakePeriod[msg.sender] = block.timestamp + 30 days;

        // Doing the transfer
        sucess = stakingToken.transferFrom(
            msg.sender,
            address(this),
            _amountToken
        );
        require(sucess == true, "Transaction Failed");
        bal[msg.sender] += _amountToken;
    }

    // function withdraw(uint256 _amountOUT) public returns (bool success) {
    //     require(
    //         block.timestamp - stakeTime[msg.sender] > 3 days,
    //         "You can only withdraw after 3 days"
    //     );
    //     // require(block.timestamp );
    // }

    function withdrawAllStake() public returns (bool sucess) {
        // require that its more that 3days and upto 30days
        require(
            block.timestamp - stakeTime[msg.sender] > 3 days,
            "You can only withdraw after 3 days"
        );
        require(block.timestamp - stakePeriod[msg.sender] > 30 days, "");
        uint256 reward = (bal[msg.sender] / 100) * 10;
        sucess = stakingToken.transfer(msg.sender, reward);
        require(sucess = true, "withdrawal failed");
        // reset staker balance to zero
        bal[msg.sender] = 0;
    }
}
