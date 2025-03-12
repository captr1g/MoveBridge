# Setup Instructions for Cross-Chain dApp

This document provides step-by-step instructions to set up the Cross-Chain dApp locally for development and testing.

## Prerequisites

Before you begin, ensure you have the following installed on your machine:

- Node.js (version 14 or higher)
- npm (Node package manager)
- Git
- A code editor (e.g., Visual Studio Code)
- A wallet that supports both Move and EVM (e.g., MetaMask)

## Clone the Repository

First, clone the repository to your local machine:

```bash
git clone https://github.com/captr1g/MoveBridge.git
cd cross-chain-dapp
```

## Install Dependencies

Navigate to the frontend directory and install the necessary dependencies:

```bash
cd frontend
npm install
```

For the smart contracts, ensure you have the required tools for Move and Solidity. You may need to install additional dependencies based on your development environment.

## Compile Smart Contracts

### Move Contracts

To compile the Move smart contracts, navigate to the `contracts/Move` directory and run:

```bash
# Command to compile Move contracts (replace with actual command)
move build
```

### EVM Contracts

To compile the EVM smart contracts, navigate to the `contracts/EVM` directory and run:

```bash
# Command to compile Solidity contracts (replace with actual command)
solc --bin --abi contract.sol -o build/
```

## Deploy Smart Contracts

Run the deployment script to deploy the smart contracts to the desired network:

```bash
cd scripts
node deploy.js
```

Ensure that your wallet is connected and has sufficient funds for deployment.

## Start the Frontend

After deploying the contracts, start the frontend application:

```bash
cd ../frontend
npm start
```

This will launch the application in your default web browser at `http://localhost:3000`.

## Additional Configuration

You may need to configure your wallet to connect to the network where the contracts are deployed. Follow the wallet's instructions for adding custom networks.

## Conclusion

You are now set up to develop and test the Cross-Chain dApp locally. For further instructions on usage and features, refer to the `usage.md` document in the `docs` directory.