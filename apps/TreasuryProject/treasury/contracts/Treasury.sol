// SPDX-License-Identifier: MIT
pragma solidity ^0.8.11;

import "@openzeppelin/contracts/interfaces/IERC20.sol";
import "@chainlink/contracts/src/v0.8/interfaces/AggregatorV3Interface.sol";
import "./TreasuryToken.sol";

contract Treasury {
    address payable public owner;

    // ERC20 Token addresses on Ropsten network
    address private immutable wethAddress = 0xd0a1e359811322d97991e03f863a0c30c2cf029c;
    address private immutable usdcAddress = 0xdcfab8057d08634279f8201b55d311c2a67897d2;

    IERC20 private weth;
    IERC20 private usdc;

    enum TokenList {
        weth,
        usdc
    }

    // keeps track of individuals' treasury WETH balances
    mapping(address => uint) public wethBalances;

    // keeps track of individuals' treasury USDC balances
    mapping(address => uint) public usdcBalances;

    AggregatorV3Interface internal priceFeed;
    /**
     * Network: Kovan
     * Aggregator: ETH/USD
     * Address: 0x9326BFA02ADD2366b30bacB125260Af641031331
     */

    // Treasury Token
    IERC20 public token;

    constructor() {
        owner = payable(msg.sender);
        weth = IERC20(wethAddress);
        usdc = IERC20(usdcAddress);
        token = new TreasuryToken(1000000);
        priceFeed = AggregatorV3Interface(0x9326BFA02ADD2366b30bacB125260Af641031331);
    }

    // deposit WETH into the treasury
    function depositWeth(uint _amount) external depositGreaterThanZero(_amount) payable {
        // update depositor's treasury WETH balance
        // update state before transfer of funds to prevent reentrancy attacks
        wethBalances[msg.sender] += _amount;

        // deposit WETH into treasury
        uint256 allowance = weth.allowance(msg.sender, address(this));
        require(allowance >= _amount, "Check the token allowance");
        weth.transferFrom(msg.sender, address(this), _amount);
    }

    // deposit USDC into the treasury
    function depositUsdc(uint _amount) external depositGreaterThanZero(_amount) payable {
        // update depositor's treasury USDC balance
        // update state before transfer of funds to prevent reentrancy attacks
        usdcBalances[msg.sender] += _amount;

        // deposit USDC into treasury
        uint256 allowance = usdc.allowance(msg.sender, address(this));
        require(allowance >= _amount, "Check the token allowance");
        usdc.transferFrom(msg.sender, address(this), _amount);
    }

    function getTreasuryWethBalance() external view returns (uint) {
        return weth.balanceOf(address(this));
    }

    function getTreasuryUsdcBalance() external view returns (uint) {
        return usdc.balanceOf(address(this));
    }

    function getTreasuryTokenBalance() external view returns (uint) {
        return token.balanceOf(address(this));
    }

    /**
     * Returns the latest price
     */
    function getLatestPrice() public view returns (int) {
        (
            uint80 roundID, 
            int price,
            uint startedAt,
            uint timeStamp,
            uint80 answeredInRound
        ) = priceFeed.latestRoundData();
        return price;
    }

    modifier depositGreaterThanZero(uint _amount) {
      require(_amount > 0, "Deposit amount must be greater than zero");
      _;
   }

    receive() external payable {}
}