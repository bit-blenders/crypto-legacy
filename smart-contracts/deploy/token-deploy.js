const { ethers } = require("hardhat");

async function main(){
  const Token = await ethers.getContractFactory("MyERC20")
  const token = await Token.deploy();
  await token.deployed();
  console.log("token deployed to Mumbai at address: ", token.address);
}

main().catch((error) => {
    console.error(error);
    process.exitCode = 1;
  });
  