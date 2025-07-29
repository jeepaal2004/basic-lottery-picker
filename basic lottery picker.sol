// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract Project {
    address public manager;
    address[] public players;

    // Event to log the winner
    event WinnerPicked(address winner, uint256 prize);

    constructor() {
        manager = msg.sender;
    }

    // Function to enter the lottery
    function enterLottery() public payable {
        require(msg.value == 0.01 ether, "Entry fee is exactly 0.01 ETH");
        players.push(msg.sender);
    }

    // Function to get list of all participants
    function getPlayers() public view returns (address[] memory) {
        return players;
    }

    // Function to pick a winner - only manager can call
    function pickWinner() public restricted {
        require(players.length > 0, "No players have entered");

        uint256 index = random() % players.length;
        address winner = players[index];
        uint256 prize = address(this).balance;

        payable(winner).transfer(prize);

        emit WinnerPicked(winner, prize);

        // Reset the players array
        players = new address[](0);
    }

    // Pseudo-random number generator (Do not use in production)
    function random() private view returns (uint256) {
        return uint256(
            keccak256(abi.encodePacked(block.timestamp, block.prevrandao, players))
        );
    }

    // Modifier to restrict access to manager
    modifier restricted() {
        require(msg.sender == manager, "Only manager can perform this action");
        _;
    }
}
