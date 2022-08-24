//SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.3;

import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/utils/math/SafeMath.sol";

error ProvideEnoughAmount();
error TimeYetToComplete();
error NotEnoughBalanceToRestake();
error  NotEnoughAmountStacked();
error LockUpPeriodYetToComplete();
error notEnoughFundsInContract();
error NotEnoughTokensToClaim();

contract StackUSDT is Ownable {
    using SafeMath for uint256;
    //stakeUSDT
    //withdraw
    //isuue rewards
    //auto compound
    //update APY
    address[] public stakers;
    address[] public autoStakers;
    address public admin;
    
   
     

    mapping(address => uint) public stacked;
    mapping(address=>uint)public OriginalStacked;
    mapping(address=>bool)public m_autoStackers;
    //mapping user --> rewards 
    mapping(address=>uint) public claimableRewards;
    //mapping user --> months staked
    mapping(address => uint) public monthsStaked;
    uint256 public immutable i_interval;
    mapping(address => uint)public duration;
    

    uint256 public s_lastTimeUpdated;
    uint public APY;

    IERC20 USD = IERC20(0xd9145CCE52D386f254917e481eB44e9943F39138);
    event AutoInvestor(address AutoInvestor);
    event UpdatedAPY(address user, uint apy);
    event IssuedTokens(uint issuedAt);
    event FundsWithdrawn(address withdrawnby, uint Amount);
    event UnStacked(address user, uint Amount);
    event RewardsClaimed(address user, uint _amount);
    constructor(uint _internal) {
        i_interval = _internal;
        admin = msg.sender;
    }
    
    function stakeUSDT(uint _amount, uint months) external {
        require(months == 1 || months == 3 || months == 6 || months == 9 || months == 12);
        if (_amount == 0) {
            revert ProvideEnoughAmount();
        }
        if (stacked[msg.sender] == 0) {
            stakers.push(msg.sender);
        }
        USD.transferFrom(msg.sender, address(this), _amount);
        if(stacked[msg.sender] == 0){
            duration[msg.sender] = block.timestamp + months*30*24*60*60;
            monthsStaked[msg.sender] = months;
        }
        stacked[msg.sender] = stacked[msg.sender] + _amount;
        OriginalStacked[msg.sender] = OriginalStacked[msg.sender]+_amount;
    }
    function checkToIssueRewards() public view returns (bool) {
        bool timePassed = (block.timestamp - s_lastTimeUpdated) > i_interval;
        return (timePassed);
    }
    function issueTokens() external {
        bool issue = checkToIssueRewards();
        if (!issue) {
            revert TimeYetToComplete();
        }
        s_lastTimeUpdated = block.timestamp;
        for (uint i = 0; i < stakers.length; i++) {
            address receiver = stakers[i];
            uint TotalTokensLocked = getTokensStacked(receiver);
            uint dailyRewards = TotalTokensLocked.mul(APY).div(36500);
            if(m_autoStackers[receiver]){
                stacked[receiver] = stacked[receiver] + dailyRewards;
            }else{
                claimableRewards[receiver] = claimableRewards[receiver] + dailyRewards;
            }
           

        }
        emit IssuedTokens(block.timestamp);
    }
    // function autoInestor(address user) private{
    //     for (uint i=0; i<autoStakers; i++){
    //         if(user == autoStakers[i]){
    //             stacked[user] = stacked[user] + dailyRaewrds;

    //         }
    //     }
    // }
    function autoReinvestRewards() external{
        autoStakers.push(msg.sender); 
        m_autoStackers[msg.sender] = true;
        emit AutoInvestor(msg.sender);
    }
    function getTokensStacked(address _user) public view returns(uint256){
        uint tokensStacked = stacked[_user];
        return tokensStacked;
    }

    function updateAPY(uint apy) onlyOwner external {
        APY = apy;
        emit UpdatedAPY(msg.sender, APY);
       
    }
    function unstake(uint amount) external{
        if(stacked[msg.sender] > 0){
            revert NotEnoughAmountStacked();
        }
        if(duration[msg.sender] < block.timestamp){
            revert LockUpPeriodYetToComplete();
        }
        uint bal = USD.balanceOf(address(this));
        if(bal < amount){
            revert notEnoughFundsInContract();
        }
        stacked[msg.sender] = stacked[msg.sender] - amount;
        USD.transfer(msg.sender, amount);
        emit UnStacked(msg.sender, amount);
    }

    function withdrawUSD(uint amount) onlyOwner external{
        uint balance = USD.balanceOf(address(this));
        if(amount > balance){
            revert notEnoughFundsInContract();
        }
        USD.transfer(admin, amount);
        emit FundsWithdrawn(admin, amount);
    }
    function ClaimRewards(uint amount) external{
        if(claimableRewards[msg.sender] < amount){
            revert NotEnoughTokensToClaim();
        }
        uint bal = USD.balanceOf(address(this));
        if(bal < amount){
            revert notEnoughFundsInContract();
        }
        claimableRewards[msg.sender] = claimableRewards[msg.sender] - amount;
        USD.transfer(msg.sender, amount);
        emit RewardsClaimed(msg.sender, amount);
    }


    //view functions
    function StackedAmount(address user) public view returns(uint256){
        uint stack = stacked[user];
        return stack;
    }
    
    function CanIUnstake(address user) public view returns(bool){
        if(duration[user] < block.timestamp){
            return true;
        }else{
            return false;
        }
    }
    
    function originalStackedAmount(address user) public view returns(uint){
        uint Ostaked = OriginalStacked[user];
        return Ostaked;
    }
    
    
}
