// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Script, console} from "forge-std/Script.sol";
import {FlowSender} from "../src/FlowSender.sol";
import {ISuperToken} from "@superfluid-finance/ethereum-contracts/contracts/interfaces/superfluid/ISuperfluid.sol";

contract FlowSenderScript is Script {
  function setUp() public {}

  /**
   * FlowSenderコントラクトをデプロイするスクリプト
   */
  function run() public {
    uint256 deployerPrivateKey = vm.envUint("PRIVATE_KEY");
    vm.startBroadcast(deployerPrivateKey);

    // FlowSenderのデプロイ
    FlowSender flowSender = new FlowSender(
      ISuperToken(address(0x9Ce2062b085A2268E8d769fFC040f6692315fd2c))
    );

    console.log("FlowSender deployed at: %s", address(flowSender));

    vm.stopBroadcast();
  }
}
