import { ethers, network } from "hardhat";
require("dotenv").config({ path: ".env" });

async function main() {
  const Owner = "0x9268d03eff4a9a595ef619764afcb9976c0375df";
  const ApeNftHolder = "0x6bf62Dad62053eB6A02451bCCf78e252C1388685";

  const OwnerSigner = await ethers.getSigner(Owner);

  //@ts-ignore
  await hre.network.provider.request({
    method: "hardhat_impersonateAccount",
    params: [Owner],
  });

  const BoredApesToken = await ethers.getContractFactory("BoredToken");
  const deployBored = await BoredApesToken.connect(OwnerSigner).deploy();
  await deployBored.deployed();

  console.log("DeployedBoredTokenAdd:", deployBored.address);

  const Balance = await deployBored.balanceOf(Owner);
  const Transfer = await deployBored
    .connect(OwnerSigner)
    .transfer(ApeNftHolder, 2000000000000);

  const BalanceOwner = await deployBored.balanceOf(Owner);
  const BalanceApeHolder = await deployBored.balanceOf(ApeNftHolder);
  console.log(BalanceOwner);
  console.log(BalanceApeHolder);
}

// Call the main function and catch if there is any error
main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error);
    process.exit(1);
  });
