import { ethers } from "hardhat";
require("dotenv").config({ path: ".env" });

async function main() {
  const ApeNftHolder = "0x6bf62Dad62053eB6A02451bCCf78e252C1388685";

  const ApeSigner = await ethers.getSigner(ApeNftHolder);

  const BoredApesNFT = "0xbc4ca0eda7647a8ab7c2061c2e118a18a936f13d";
  const BoredTokenAdd = "0xFa80f5bCBb8BA262C5Add182101Ff4C569991b11";

  const stakeContract = await ethers.getContractFactory("stakingBrt");
  const deployStake = await stakeContract.deploy(BoredTokenAdd, BoredApesNFT);
  await deployStake.deployed();

  console.log("DeployedStakeTokenAdd:", deployStake.address);

  await deployStake.connect(ApeSigner).stakeToken(200000000000);
  console.log("stake successful");
}

// Call the main function and catch if there is any error
main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error);
    process.exit(1);
  });
