import {ethers, network, run} from "hardhat";
import {writeContractAddress} from "../helper/contractsJsonHelper";

/**
 * モックコントラクトのデプロイ
 */
async function main() {
  // SuperToken Address
  const superTokenAddress = "0xd6faf98befa647403cc56bdb598690660d5257d2";

  const flowSender = await ethers.deployContract("FlowSender", [
    superTokenAddress,
  ]);

  console.log(` ======================= start ========================= `);
  await flowSender.deployed();

  console.log(` FlowSender Contract deployed to ${flowSender.address}`);

  await run(`verify:verify`, {
    contract: "contracts/FlowSender.sol:FlowSender",
    address: flowSender.address,
    constructorArguments: [superTokenAddress],
  });

  // write Contract Address
  writeContractAddress({
    group: "contracts",
    name: "FlowSender",
    value: flowSender.address,
    network: network.name,
  });
  console.log(` ======================== end  ======================== `);
}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
