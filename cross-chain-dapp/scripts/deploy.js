const { ethers } = require("hardhat");

async function main() {
    // Deploy Move contract
    const MoveContract = await ethers.getContractFactory("MoveContract");
    const moveContract = await MoveContract.deploy();
    await moveContract.deployed();
    console.log("Move contract deployed to:", moveContract.address);

    // Deploy EVM contract
    const EVMContract = await ethers.getContractFactory("EVMContract");
    const evmContract = await EVMContract.deploy();
    await evmContract.deployed();
    console.log("EVM contract deployed to:", evmContract.address);

    // Integrate with Polygon AggLayer
    // Add your integration logic here

    console.log("Deployment completed successfully.");
}

main()
    .then(() => process.exit(0))
    .catch((error) => {
        console.error(error);
        process.exit(1);
    });