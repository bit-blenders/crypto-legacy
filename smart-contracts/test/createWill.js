const { ethers } = require("hardhat");
// const { address, abi } = require("../build/mumbai/Legacy.json");
const {abi1} = require('../abi/legacyAbi.json')
const {abi} = require('../abi/tokenAbi.json')
async function main() {
    const [ owner, account1 ] = await ethers.getSigners();

    const legacyContract = await ethers.getContractAt("0xD9b4940B748d8C892D3112f78f15EA37f5712159", abi1);
    
    const tokenContract = await ethers.getContractAt("0x84600C18ca1B7EC74a5369F593e30d4F22B007ee", abi);
    // const legacy = await Legacy.deploy();
    // await legacy.deployed();
    initBal = await tokenContract.balanceOf(account1)
    console.log(`The init balance of ${account1} = ${initBal}`);

    const asset = {
        assetAddress: tokenContract.address,
        assetType: 0,
        expiresAt: "1670100800",
        allowance: ethers.utils.parseUnits("0.1"),
        recepients: [
            {
                receiver: account1.address,
                sharePercentBps: 100,
                denominator: 100,
                id: 0
            }
        ],
    };

    try {
        tx = await legacyContract.createWill(asset).catch((e) => {throw e});
        // tx = await tx.wait();
        console.log("Success");
    }
    catch(err) {
        console.log(err);
        // tx = await tx.wait();
        console.log("Failed");
    }

}