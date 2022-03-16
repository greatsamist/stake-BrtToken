const { ethers } = require("hardhat");
require("dotenv").config({ path: ".env" });

async function main() {
  const BoredApesToken = await ethers.getContractFactory("BoredToken");
  const deployBored = await BoredApesToken.deploy();
  await deployBored.deployed();
}

// Call the main function and catch if there is any error
main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error);
    process.exit(1);
  });
