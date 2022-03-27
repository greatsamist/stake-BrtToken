/*  
Write  a staking contract that accepts an erc20 token called boredApeToken(created by you,18 decimasls)

- When people stake brt, they 10% of it per month provided they have staked for 3 days or more
- IMPORTANT: Only BoredApes owners can use your contract

BOREDAPES NFT Contract Address: 0xbc4ca0eda7647a8ab7c2061c2e118a18a936f13d
*/

//SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.4;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/token/ERC721/IERC721.sol";
import "@openzeppelin/contracts/security/ReentrancyGuard.sol";

contract stakingBrt is ReentrancyGuard {
    IERC20 BrtToken;
    IERC721 BoredApesNFT;

    // stake minimum time is 3 days or no reward
    uint96 constant minPeriod = 259200;

    // uint256 public lastUpdateTime;
    mapping(address => uint256) public lastUpdateTime;

    // when user stores or withdraw some tokens, this will update
    mapping(address => uint256) public rewards;
    // @_balances, number of token staked per user
    mapping(address => uint256) public _balances;

    constructor(address _BrtToken, address _BoredApesNFT) {
        BrtToken = IERC20(_BrtToken);
        BoredApesNFT = IERC721(_BoredApesNFT);
    }

    function rewardPerToken() public view returns (uint256) {
        require(
            block.timestamp - lastUpdateTime[msg.sender] >= minPeriod,
            "Not up to 3 days"
        );
        uint256 initialAmount = _balances[msg.sender] * 1e18;
        uint256 basePerMonth = (initialAmount * 10) / 100;
        uint256 _rewardPerSec = basePerMonth / 2592000;
        return _rewardPerSec;
    }

    // @earned, the amount of tokens the user has earned
    function earned(address account) public view returns (uint256) {
        uint256 stakePeriod = block.timestamp - lastUpdateTime[account];
        uint256 earn = stakePeriod * rewardPerToken();
        return earn;
    }

    function updateReward(address account) internal {
        // A require statement that the address own BoredNFT
        require(
            BoredApesNFT.balanceOf(account) >= 1,
            "You don't own BoredApes NFT's"
        );
        // checking if the user already has rewards
        if (rewards[account] == 0) {
            rewards[account] = earned(account);
        } else {
            rewards[account] += earned(account);
        }

        // updating the time to current time
        lastUpdateTime[msg.sender] = block.timestamp;
    }

    // @stake, to stake there tokens
    function stake(uint256 _amount) public {
        // BrtToken.transferFrom(msg.sender, address(this), _amount);
        _balances[msg.sender] += _amount;
        updateReward(msg.sender);
        emit Staked(msg.sender, _amount);
    }

    // @withdraw, to unstake there tokens
    function withdraw(uint256 _amount) public {
        _balances[msg.sender] -= _amount;
        // BrtToken.transfer(msg.sender, _amount);
        updateReward(msg.sender);
        emit Withdrawn(msg.sender, _amount);
    }

    // @getReward to claim there token rewards
    function getReward() public nonReentrant {
        uint256 reward = rewards[msg.sender];
        if (reward > 0) {
            rewards[msg.sender] = 0;
            // BrtToken.transfer(msg.sender, reward);
            emit RewardPaid(msg.sender, reward);
        }
        updateReward(msg.sender);
    }

    // @exit, to withdraww all stake plus reward
    function exit() external {
        withdraw(_balances[msg.sender]);
        getReward();
    }

    //======== EVENTS ========//

    event Staked(address indexed user, uint256 amount);
    event Withdrawn(address indexed user, uint256 amount);
    event RewardPaid(address indexed user, uint256 reward);
}
