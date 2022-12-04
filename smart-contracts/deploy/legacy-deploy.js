const { ethers, network } = require("hardhat");

async function main(){
  const [account1] = await ethers.getSigners();
  const Legacy = await ethers.getContractFactory("Legacy")
  const legacy = await Legacy.deploy();
  await legacy.deployed();
  console.log("Legacy deployed to Mumbai at address: ", legacy.address);
}

main().catch((error) => {
    console.error(error);
    process.exitCode = 1;
  });
  