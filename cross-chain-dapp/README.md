# Cross-Chain Decentralized Application (dApp)

This project is a cross-chain decentralized application (dApp) that integrates Movement Labs’ Move and EVM support with Polygon AggLayer for interoperability. The dApp allows users to interact with both Move and EVM smart contracts seamlessly.

## Project Structure

The project is organized as follows:

```
cross-chain-dapp
├── contracts
│   ├── Move
│   │   └── contract.move         # Move smart contract code
│   ├── EVM
│   │   └── contract.sol           # Solidity smart contract code
├── frontend
│   ├── src
│   │   ├── components
│   │   │   └── App.tsx            # Main React component
│   │   ├── pages
│   │   │   └── Home.tsx           # Home page component
│   │   ├── styles
│   │   │   └── main.css           # CSS styles
│   │   └── index.tsx              # Entry point for React application
│   ├── package.json                # Frontend configuration
│   ├── tsconfig.json               # TypeScript configuration
│   └── README.md                   # Frontend documentation
├── scripts
│   └── deploy.js                   # Deployment script for smart contracts
├── tests
│   └── example.test.js             # Example test file
├── docs
│   ├── architecture.md             # Architecture overview
│   ├── setup.md                    # Setup instructions
│   └── usage.md                    # User guide
├── README.md                       # Main project documentation
└── package.json                    # Overall project configuration
```

## Installation

To get started with the project, follow these steps:

1. Clone the repository:
   ```
   git clone <repository-url>
   cd cross-chain-dapp
   ```

2. Install dependencies for the frontend:
   ```
   cd frontend
   npm install
   ```

3. Install dependencies for the smart contracts (if applicable):
   ```
   cd contracts
   npm install
   ```

## Usage

To run the frontend application, navigate to the `frontend` directory and execute:
```
npm start
```

For deploying the smart contracts, run the deployment script:
```
node scripts/deploy.js
```

## Move Contract
To compile the Move contract located in `contracts/Move`, install the Move CLI and run:
```
aptos move compile
```
Then deploy it to your desired network as needed.

## Testing
For testing, run:
```
npm test
```
This command executes the project's test suite for both Move and EVM contracts (if applicable).

## Documentation

- [Frontend Documentation](frontend/README.md)
- [Architecture Overview](docs/architecture.md)
- [Setup Instructions](docs/setup.md)
- [User Guide](docs/usage.md)

## Contributing

Contributions are welcome! Please submit a pull request or open an issue for any enhancements or bug fixes.

## License

This project is licensed under the MIT License. See the LICENSE file for more details.