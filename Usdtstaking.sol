
// File: @openzeppelin/contracts/utils/math/SafeMath.sol


// OpenZeppelin Contracts (last updated v4.6.0) (utils/math/SafeMath.sol)

pragma solidity ^0.8.0;

// CAUTION
// This version of SafeMath should only be used with Solidity 0.8 or later,
// because it relies on the compiler's built in overflow checks.

/**
 * @dev Wrappers over Solidity's arithmetic operations.
 *
 * NOTE: `SafeMath` is generally not needed starting with Solidity 0.8, since the compiler
 * now has built in overflow checking.
 */
library SafeMath {
    /**
     * @dev Returns the addition of two unsigned integers, with an overflow flag.
     *
     * _Available since v3.4._
     */
    function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
        unchecked {
            uint256 c = a + b;
            if (c < a) return (false, 0);
            return (true, c);
        }
    }

    /**
     * @dev Returns the subtraction of two unsigned integers, with an overflow flag.
     *
     * _Available since v3.4._
     */
    function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
        unchecked {
            if (b > a) return (false, 0);
            return (true, a - b);
        }
    }

    /**
     * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
     *
     * _Available since v3.4._
     */
    function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
        unchecked {
            // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
            // benefit is lost if 'b' is also tested.
            // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
            if (a == 0) return (true, 0);
            uint256 c = a * b;
            if (c / a != b) return (false, 0);
            return (true, c);
        }
    }

    /**
     * @dev Returns the division of two unsigned integers, with a division by zero flag.
     *
     * _Available since v3.4._
     */
    function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
        unchecked {
            if (b == 0) return (false, 0);
            return (true, a / b);
        }
    }

    /**
     * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
     *
     * _Available since v3.4._
     */
    function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
        unchecked {
            if (b == 0) return (false, 0);
            return (true, a % b);
        }
    }

    /**
     * @dev Returns the addition of two unsigned integers, reverting on
     * overflow.
     *
     * Counterpart to Solidity's `+` operator.
     *
     * Requirements:
     *
     * - Addition cannot overflow.
     */
    function add(uint256 a, uint256 b) internal pure returns (uint256) {
        return a + b;
    }

    /**
     * @dev Returns the subtraction of two unsigned integers, reverting on
     * overflow (when the result is negative).
     *
     * Counterpart to Solidity's `-` operator.
     *
     * Requirements:
     *
     * - Subtraction cannot overflow.
     */
    function sub(uint256 a, uint256 b) internal pure returns (uint256) {
        return a - b;
    }

    /**
     * @dev Returns the multiplication of two unsigned integers, reverting on
     * overflow.
     *
     * Counterpart to Solidity's `*` operator.
     *
     * Requirements:
     *
     * - Multiplication cannot overflow.
     */
    function mul(uint256 a, uint256 b) internal pure returns (uint256) {
        return a * b;
    }

    /**
     * @dev Returns the integer division of two unsigned integers, reverting on
     * division by zero. The result is rounded towards zero.
     *
     * Counterpart to Solidity's `/` operator.
     *
     * Requirements:
     *
     * - The divisor cannot be zero.
     */
    function div(uint256 a, uint256 b) internal pure returns (uint256) {
        return a / b;
    }

    /**
     * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
     * reverting when dividing by zero.
     *
     * Counterpart to Solidity's `%` operator. This function uses a `revert`
     * opcode (which leaves remaining gas untouched) while Solidity uses an
     * invalid opcode to revert (consuming all remaining gas).
     *
     * Requirements:
     *
     * - The divisor cannot be zero.
     */
    function mod(uint256 a, uint256 b) internal pure returns (uint256) {
        return a % b;
    }

    /**
     * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
     * overflow (when the result is negative).
     *
     * CAUTION: This function is deprecated because it requires allocating memory for the error
     * message unnecessarily. For custom revert reasons use {trySub}.
     *
     * Counterpart to Solidity's `-` operator.
     *
     * Requirements:
     *
     * - Subtraction cannot overflow.
     */
    function sub(
        uint256 a,
        uint256 b,
        string memory errorMessage
    ) internal pure returns (uint256) {
        unchecked {
            require(b <= a, errorMessage);
            return a - b;
        }
    }

    /**
     * @dev Returns the integer division of two unsigned integers, reverting with custom message on
     * division by zero. The result is rounded towards zero.
     *
     * Counterpart to Solidity's `/` operator. Note: this function uses a
     * `revert` opcode (which leaves remaining gas untouched) while Solidity
     * uses an invalid opcode to revert (consuming all remaining gas).
     *
     * Requirements:
     *
     * - The divisor cannot be zero.
     */
    function div(
        uint256 a,
        uint256 b,
        string memory errorMessage
    ) internal pure returns (uint256) {
        unchecked {
            require(b > 0, errorMessage);
            return a / b;
        }
    }

    /**
     * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
     * reverting with custom message when dividing by zero.
     *
     * CAUTION: This function is deprecated because it requires allocating memory for the error
     * message unnecessarily. For custom revert reasons use {tryMod}.
     *
     * Counterpart to Solidity's `%` operator. This function uses a `revert`
     * opcode (which leaves remaining gas untouched) while Solidity uses an
     * invalid opcode to revert (consuming all remaining gas).
     *
     * Requirements:
     *
     * - The divisor cannot be zero.
     */
    function mod(
        uint256 a,
        uint256 b,
        string memory errorMessage
    ) internal pure returns (uint256) {
        unchecked {
            require(b > 0, errorMessage);
            return a % b;
        }
    }
}

// File: @openzeppelin/contracts/token/ERC20/IERC20.sol


// OpenZeppelin Contracts (last updated v4.6.0) (token/ERC20/IERC20.sol)

pragma solidity ^0.8.0;

/**
 * @dev Interface of the ERC20 standard as defined in the EIP.
 */
interface IERC20 {
    /**
     * @dev Emitted when `value` tokens are moved from one account (`from`) to
     * another (`to`).
     *
     * Note that `value` may be zero.
     */
    event Transfer(address indexed from, address indexed to, uint256 value);

    /**
     * @dev Emitted when the allowance of a `spender` for an `owner` is set by
     * a call to {approve}. `value` is the new allowance.
     */
    event Approval(address indexed owner, address indexed spender, uint256 value);

    /**
     * @dev Returns the amount of tokens in existence.
     */
    function totalSupply() external view returns (uint256);

    /**
     * @dev Returns the amount of tokens owned by `account`.
     */
    function balanceOf(address account) external view returns (uint256);

    /**
     * @dev Moves `amount` tokens from the caller's account to `to`.
     *
     * Returns a boolean value indicating whether the operation succeeded.
     *
     * Emits a {Transfer} event.
     */
    function transfer(address to, uint256 amount) external returns (bool);

    /**
     * @dev Returns the remaining number of tokens that `spender` will be
     * allowed to spend on behalf of `owner` through {transferFrom}. This is
     * zero by default.
     *
     * This value changes when {approve} or {transferFrom} are called.
     */
    function allowance(address owner, address spender) external view returns (uint256);

    /**
     * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
     *
     * Returns a boolean value indicating whether the operation succeeded.
     *
     * IMPORTANT: Beware that changing an allowance with this method brings the risk
     * that someone may use both the old and the new allowance by unfortunate
     * transaction ordering. One possible solution to mitigate this race
     * condition is to first reduce the spender's allowance to 0 and set the
     * desired value afterwards:
     * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
     *
     * Emits an {Approval} event.
     */
    function approve(address spender, uint256 amount) external returns (bool);

    /**
     * @dev Moves `amount` tokens from `from` to `to` using the
     * allowance mechanism. `amount` is then deducted from the caller's
     * allowance.
     *
     * Returns a boolean value indicating whether the operation succeeded.
     *
     * Emits a {Transfer} event.
     */
    function transferFrom(
        address from,
        address to,
        uint256 amount
    ) external returns (bool);
}

// File: @openzeppelin/contracts/utils/Context.sol


// OpenZeppelin Contracts v4.4.1 (utils/Context.sol)

pragma solidity ^0.8.0;

/**
 * @dev Provides information about the current execution context, including the
 * sender of the transaction and its data. While these are generally available
 * via msg.sender and msg.data, they should not be accessed in such a direct
 * manner, since when dealing with meta-transactions the account sending and
 * paying for execution may not be the actual sender (as far as an application
 * is concerned).
 *
 * This contract is only required for intermediate, library-like contracts.
 */
abstract contract Context {
    function _msgSender() internal view virtual returns (address) {
        return msg.sender;
    }

    function _msgData() internal view virtual returns (bytes calldata) {
        return msg.data;
    }
}

// File: @openzeppelin/contracts/access/Ownable.sol


// OpenZeppelin Contracts (last updated v4.7.0) (access/Ownable.sol)

pragma solidity ^0.8.0;


/**
 * @dev Contract module which provides a basic access control mechanism, where
 * there is an account (an owner) that can be granted exclusive access to
 * specific functions.
 *
 * By default, the owner account will be the one that deploys the contract. This
 * can later be changed with {transferOwnership}.
 *
 * This module is used through inheritance. It will make available the modifier
 * `onlyOwner`, which can be applied to your functions to restrict their use to
 * the owner.
 */
abstract contract Ownable is Context {
    address private _owner;

    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);

    /**
     * @dev Initializes the contract setting the deployer as the initial owner.
     */
    constructor() {
        _transferOwnership(_msgSender());
    }

    /**
     * @dev Throws if called by any account other than the owner.
     */
    modifier onlyOwner() {
        _checkOwner();
        _;
    }

    /**
     * @dev Returns the address of the current owner.
     */
    function owner() public view virtual returns (address) {
        return _owner;
    }

    /**
     * @dev Throws if the sender is not the owner.
     */
    function _checkOwner() internal view virtual {
        require(owner() == _msgSender(), "Ownable: caller is not the owner");
    }

    /**
     * @dev Leaves the contract without owner. It will not be possible to call
     * `onlyOwner` functions anymore. Can only be called by the current owner.
     *
     * NOTE: Renouncing ownership will leave the contract without an owner,
     * thereby removing any functionality that is only available to the owner.
     */
    function renounceOwnership() public virtual onlyOwner {
        _transferOwnership(address(0));
    }

    /**
     * @dev Transfers ownership of the contract to a new account (`newOwner`).
     * Can only be called by the current owner.
     */
    function transferOwnership(address newOwner) public virtual onlyOwner {
        require(newOwner != address(0), "Ownable: new owner is the zero address");
        _transferOwnership(newOwner);
    }

    /**
     * @dev Transfers ownership of the contract to a new account (`newOwner`).
     * Internal function without access restriction.
     */
    function _transferOwnership(address newOwner) internal virtual {
        address oldOwner = _owner;
        _owner = newOwner;
        emit OwnershipTransferred(oldOwner, newOwner);
    }
}

// File: V2USDTstake.sol

//SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.3;




error ProvideEnoughAmount();
error TimeYetToComplete();
error NotEnoughBalanceToRestake();
error NotEnoughAmountStacked();
error LockUpPeriodYetToComplete();
error notEnoughFundsInContract();
error NotEnoughTokensToClaim();
error NotEnoughAmountStaked();
error LockUpTimeYetToComplete();

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
    struct stakes {
        address owner;
        uint amount;
        uint startTime;
        uint endTime;
        uint months;
        bool colleted;
        uint claimed;
        uint CompundedAmount;
    }

    // mapping(address => uint) public stacked;
    // mapping(address => uint) public OriginalStacked;
    mapping(address => bool) public m_autoStackers;
    //mapping user --> rewards
    mapping(address => uint) public claimableRewards;
    //mapping user --> months staked
    // mapping(address => uint) public monthsStaked;
    uint256 public immutable i_interval;
    //mapping for months and apy
    mapping(uint => uint) public APY;
    //mapping for address and the stakes array
    mapping(address => stakes[]) public Stakes;
    //mapping address --> number of stakes
    // mapping(address => uint) public userStakes;
    uint256 public s_lastTimeUpdated;
    //removed that months mapping because we can store it in struct node only and it was not useful as the user stakes again it will store that month and remove previous one(tarun change)

    //IERC20 USD = IERC20(0xd9145CCE52D386f254917e481eB44e9943F39138);
    IERC20 USD= IERC20(0xd9145CCE52D386f254917e481eB44e9943F39138);
    event AutoInvestor(address AutoInvestor);
    event UpdatedAPY(address user, uint apy);
    event IssuedTokens(uint issuedAt);
    event FundsWithdrawn(address withdrawnby, uint Amount);
    event UnStacked(address user, uint Amount);
    event RewardsClaimed(address user, uint _amount);
    event UpdatedStaking(
        address user,
        uint amount,
        uint startTime,
        uint endTime,
        uint months,
        bool colleted,
        uint claimed,
        uint CompundedAmount
    );
    event UnStackedTokens(
        address user,
        uint stakeId,
        uint compoundedamount,
        uint claimed
    );

    constructor(uint _internal) {
        i_interval = _internal;
        admin = msg.sender;
    }

    function stakeUSDT(uint _amount, uint months) external {
        require(
            months == 1 ||
                months == 3 ||
                months == 6 ||
                months == 9 ||
                months == 12
        );
        uint USDallowedAmt=USD.allowance(msg.sender,address(this));
        require(_amount<=USDallowedAmt,"Please approve from usd contract");
        //allowance statement check was missing(tarun change)
        if (_amount == 0) {
            revert ProvideEnoughAmount();
        }
        USD.transferFrom(msg.sender, address(this), _amount);
        // uint duration = block.timestamp + months * 30 * 24 * 60 * 60;
        uint duration = block.timestamp + months *30 ;
        Stakes[msg.sender].push(
            stakes(
                msg.sender,
                _amount,
                block.timestamp,
                duration,
                months,
                false,
                0,
                _amount
            )
        );
        emit UpdatedStaking(
            msg.sender,
            _amount,
            block.timestamp,
            duration,
            months,
            false,
            0,
            _amount
        );
    }
    function noOFStakes() view public returns(uint){
        return Stakes[msg.sender].length;
    }
    function monthsStaked(uint stakeid) view public returns(uint){
        return Stakes[msg.sender][stakeid].months;
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
            getSingleUserStackvalue(receiver);
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
    function getSingleUserStackvalue(address user) private {
        for (uint i = 0; i < Stakes[user].length; i++) {//changed to Stakes[user].length because it is same as userStakes(taruns change)
            uint mnt = Stakes[user][i].months;
            uint amt = Stakes[user][i].CompundedAmount;
            uint dailyrewards = amt.mul(APY[mnt]).div(36500);
            if (m_autoStackers[user]) {
                Stakes[user][i].CompundedAmount =
                    Stakes[user][i].CompundedAmount +
                    dailyrewards;
            } else {
                claimableRewards[user] = claimableRewards[user] + dailyrewards;
            }
        }
    }
    function autoReinvestRewards() external {
        autoStakers.push(msg.sender);
        m_autoStackers[msg.sender] = true;
        emit AutoInvestor(msg.sender);
    }
    /*@dev Unstake
     **/

    function setApy(uint[] memory apy) external onlyOwner {
        require(apy.length == 5, "5 indexed array is required");
        APY[1] = apy[0];
        APY[3] = apy[1];
        APY[6] = apy[2];
        APY[9] = apy[3];
        APY[12] = apy[4];
    }
    function unStake(uint amount, uint stakeId) external {
        uint stakedAmount = Stakes[msg.sender][stakeId].CompundedAmount;
        require(stakedAmount>=amount,"amount must be less than staked amount");//removed if check and added require check(tarun change)
        uint duration = Stakes[msg.sender][stakeId].endTime;
        if (block.timestamp < duration) {
            revert LockUpTimeYetToComplete();
        }
        uint bal = USD.balanceOf(address(this));
        if (bal < amount) {
            revert notEnoughFundsInContract();
        }
        Stakes[msg.sender][stakeId].claimed =
            Stakes[msg.sender][stakeId].claimed +
            amount;
        Stakes[msg.sender][stakeId].CompundedAmount = Stakes[msg.sender][stakeId].CompundedAmount - amount;
        USD.transfer(msg.sender, amount);

        emit UnStackedTokens(msg.sender, stakeId, stakedAmount, amount);
    }
    function withdrawUSD(uint amount) external onlyOwner {
        uint balance = USD.balanceOf(address(this));
        if (amount > balance) {
            revert notEnoughFundsInContract();
        }
        USD.transfer(admin, amount);
        emit FundsWithdrawn(admin, amount);
    }
    function ClaimRewards(uint amount) external {
        if (claimableRewards[msg.sender] < amount) {
            revert NotEnoughTokensToClaim();
        }
        uint bal = USD.balanceOf(address(this));
        if (bal < amount) {
            revert notEnoughFundsInContract();
        }
        claimableRewards[msg.sender] = claimableRewards[msg.sender] - amount;
        USD.transfer(msg.sender, amount);
        emit RewardsClaimed(msg.sender, amount);
    }

}
