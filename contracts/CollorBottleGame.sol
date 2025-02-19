// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.28;

contract ColorBottleGame {
    uint256[5] private correctArrangement; 
    uint256 private attemptsLeft = 5; 
    bool private gameWon = false; 

    // Constructor to initialize the correct arrangement randomly
    constructor() {
        uint256 seed = uint256(keccak256(abi.encodePacked(block.timestamp, block.prevrandao)));
        for (uint256 i = 0; i < 5; i++) {
            correctArrangement[i] = (seed % 5) + 1;
            seed = seed / 5;
        }
    }

    // Function to check the player's arrangement
    function checkArrangement(uint256[5] memory playerArrangement) public returns (uint256) {
        require(attemptsLeft > 0, "No attempts left. Start a new game.");
        require(!gameWon, "You already won. Start a new game.");

        uint256 correctCount = 0;
        for (uint256 i = 0; i < 5; i++) {
            if (playerArrangement[i] == correctArrangement[i]) {
                correctCount++;
            }
        }

        attemptsLeft--;

        if (correctCount == 5) {
            gameWon = true;
        }

        if (attemptsLeft == 0 && !gameWon) {
            shuffleBottles();
        }

        return correctCount;
    }

    // Function to shuffle the bottles after 5 attempts
    function shuffleBottles() private {
        uint256 seed = uint256(keccak256(abi.encodePacked(block.timestamp, block.prevrandao)));
        for (uint256 i = 0; i < 5; i++) {
            correctArrangement[i] = (seed % 5) + 1;
            seed = seed / 5;
        }
        attemptsLeft = 5;
    }

    // Function to start a new game
    function newGame() public {
        shuffleBottles();
        gameWon = false;
    }

    // Function to get the number of attempts left
    function getAttemptsLeft() public view returns (uint256) {
        return attemptsLeft;
    }

    // Function to check if the game is won
    function isGameWon() public view returns (bool) {
        return gameWon;
    }
}