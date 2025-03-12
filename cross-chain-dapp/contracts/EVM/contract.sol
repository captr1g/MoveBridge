pragma solidity ^0.8.0;

contract CrossChainDApp {
    string public name = "Cross-Chain DApp";
    address public owner;

    event TokenSwapped(address indexed from, address indexed to, uint256 amount);
    event LiquidityAdded(address indexed provider, uint256 amount);

    modifier onlyOwner() {
        require(msg.sender == owner, "Not the contract owner");
        _;
    }

    constructor() {
        owner = msg.sender;
    }

    function swapTokens(address to, uint256 amount) external {
        // Logic for token swapping
        emit TokenSwapped(msg.sender, to, amount);
    }

    function addLiquidity(uint256 amount) external {
        // Logic for adding liquidity
        emit LiquidityAdded(msg.sender, amount);
    }

    function getOwner() external view returns (address) {
        return owner;
    }
}