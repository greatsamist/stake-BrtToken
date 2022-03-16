const { ethers } = require("hardhat");
require("dotenv").config({ path: ".env" });

async function main() {
const BoredApesNFT = 0xbc4ca0eda7647a8ab7c2061c2e118a18a936f13d;
const BoredTokenAdd;

const stakeContract = await ethers.getContractFactory("stakeBrt");
const deployStake  = await stakeContract.deploy()

}

// Call the main function and catch if there is any error
main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error);
    process.exit(1);
  });
