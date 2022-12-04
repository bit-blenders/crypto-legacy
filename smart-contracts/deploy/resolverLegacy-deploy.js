const { ethers } = require("hardhat");

async function main(){
  const Resolver = await ethers.getContractFactory("LegacyResolver")
  const resolver = await Resolver.deploy();
  await resolver.deployed();
  console.log("resolver deployed to Mumbai at address: ", resolver.address);
}

main().catch((error) => {
    console.error(error);
    process.exitCode = 1;
  });



  
import { GelatoOpsSDK } from "@gelatonetwork/ops-sdk";
const gelatoOps = new GelatoOpsSDK(80001, signer);
const legacy = new ethers.Contract(LEGACY_ADDRESS, legacyAbi, signer);
const resolver = new ethers.Contract(LEGACY_RESOLVER_ADDRESSES, legacyResolverAbi, signer);
const selector = legacy.interface.getSighash("executeWill(address,address)");


function createTaskWill(){
    const resolverData = resolver.interface.getSighash("checker(address,address)",(owner,assetAddress));
    const { taskId, tx } = await gelatoOps.createTask({
      execAddress: legacy.address,
      execSelector: selector,
      resolverAddress: resolver.address,
      resolverData: resolverData,
      name: "Automating legacy using resolver",
      dedicatedMsgSender: true
    });
  
    await tx.wait();
    console.log(`Task created, taskId: ${taskId} (tx hash: ${tx.hash})`);
    console.log(`> https://app.gelato.network/task/${taskId}?chainId=${chainId}`);
}