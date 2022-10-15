// SPDX-License-Identifier: MIT

pragma solidity ^0.8.17;
import "@chainlink/contracts/src/v0.8/VRFConsumerBase.sol";
import "@chainlink/contracts/src/v0.8/interfaces/AggregatorV3Interface.sol";

contract Lottery is VRFConsumerBase {
    address public owner;
    address payable[] public players;
    uint256 public lotteryId;
    mapping(uint256 => address payable) public lotteryHistory;

    bytes32 internal keyHash; // identifies which Chainlink oracle to use
    uint256 internal fee; // fee to get random number
    uint256 public randomResult;

    constructor()
        VRFConsumerBase(
            0x271682DEB8C4E0901D1a1550aD2e64D568E69909, // VRF coordinator
            0x326C977E6efc84E512bB9C30f76E30c160eD06FB // LINK token address
        )
    {
        keyHash = 0x8af398995b04c28e9951adb9721ef74c74f93e6a478f39e7e0777be13527e7ef;
        fee = 0.1 * 10**18; // 0.1 LINK

        owner = msg.sender;
        lotteryId = 10;
        // lotteryId = 4 * uint8(5);
    }

    function getRandomNumber() public returns (bytes32 requestId) {
        require(
            LINK.balanceOf(address(this)) >= fee,
            "Not enough LINK in contract"
        );
        return requestRandomness(keyHash, fee);
    }

    function fulfillRandomness(bytes32 requestId, uint256 randomness)
        internal
        override
    {
        randomResult = randomness;
    }

    function getWinnerByLottery(uint256 lottery)
        public
        view
        returns (address payable)
    {
        return lotteryHistory[lottery];
    }

    function getBalance() public view returns (uint256) {
        return address(this).balance;
    }

    function getPlayers() public view returns (address payable[] memory) {
        return players;
    }

    function enter() public payable {
        require(msg.value > .01 ether);

        // address of player entering lottery
        players.push(payable(msg.sender));
    }

    function pickWinner() public onlyowner {
        getRandomNumber();
    }

    function payWinner() public {
        require(
            randomResult > 0,
            "Must have a source of randomness before choosing winner"
        );
        uint256 index = randomResult % players.length;
        players[index].transfer(address(this).balance);

        lotteryHistory[lotteryId] = players[index];
        lotteryId++;
        // reset the state of the contract
        players = new address payable[](0);
        randomResult = 0;
        // emit Deposit(msg.sender, _id, msg.value);
    }

    modifier onlyowner() {
        require(msg.sender == owner);
        _;
    }
}
