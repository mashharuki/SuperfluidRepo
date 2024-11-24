// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Script, console} from "forge-std/Script.sol";
import {FlowSender} from "../src/FlowSender.sol";
import {ISuperToken} from "@superfluid-finance/ethereum-contracts/contracts/interfaces/superfluid/ISuperfluid.sol";
import {DistributionContract} from "../src/DistributionContract.sol";

contract DistributionContractScript is Script {
  function setUp() public {}

  /**
   * DistributionContractコントラクトをデプロイするスクリプト
   */
  function run() public {
    uint256 deployerPrivateKey = vm.envUint("PRIVATE_KEY");
    vm.startBroadcast(deployerPrivateKey);

    // DistributionContractのデプロイ
    DistributionContract distributionContract = new DistributionContract(
      ISuperToken(address(0x9Ce2062b085A2268E8d769fFC040f6692315fd2c))
    );

    console.log(
      "DistributionContract deployed at: %s",
      address(distributionContract)
    );

    vm.stopBroadcast();
  }
}
