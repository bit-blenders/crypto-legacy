const { ethers } = require("hardhat");
// const { address, abi } = require("../build/mumbai/Legacy.json");

async function main() {
    const [ owner, account1 ] = await ethers.getSigners();

    const Legacy = await ethers.getContractFactory("Legacy");
    const legacy = await Legacy.deploy();
    await legacy.deployed();

    const MyERC20 = await ethers.getContractFactory("MyERC20");
    const myErc20 = await MyERC20.deploy();
    await myErc20.deployed();

    let tx = await myErc20.approve(legacy.address, ethers.utils.parseUnits("10"));
    await tx.wait()

    const asset = {
        assetAddress: myErc20.address,
        assetType: 0,
        expiresAt: "1670100800",
        allowance: ethers.utils.parseUnits("10"),
        recepients: [
            {
                receiver: "0x70997970C51812dc3A010C7d01b50e0d17dc79C8",
                sharePercentBps: 100,
                denominator: 100,
                id: 0
            }
        ],
    };

    try {
        tx = await legacy.createWill(asset).catch((e) => {throw e});
        // tx = await tx.wait();
        console.log("Success");
    }
    catch(err) {
        console.log(err);
        // tx = await tx.wait();
        console.log("Failed");
    }
    initBal = await myErc20.balanceOf(account1.address)
    console.log(`INit Bal = ${initBal}`);
    await legacy.executeWill(owner.address, myErc20.address)

    finalBal = await myErc20.balanceOf(account1.address)
    console.log(`Final Bal = ${finalBal}`);
}

main().catch((error) => {
    console.error(error);
    process.exitCode = 1;
  });
  