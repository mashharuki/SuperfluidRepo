// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Script, console} from "forge-std/Script.sol";
import {FlowSplitter} from "../src/FlowSplitter.sol";
import {ISuperToken} from "@superfluid-finance/ethereum-contracts/contracts/interfaces/superfluid/ISuperfluid.sol";

contract FlowSplitterScript is Script {
  function setUp() public {}

  /**
   * FlowSplitterコントラクトをデプロイするスクリプト
   */
  function run() public {
    uint256 deployerPrivateKey = vm.envUint("PRIVATE_KEY");
    vm.startBroadcast(deployerPrivateKey);

    // creator アドレス
    address creator = 0x51908F598A5e0d8F1A3bAbFa6DF76F9704daD072;
    // mainReceiver アドレス
    address mainReceiver = 0x51908F598A5e0d8F1A3bAbFa6DF76F9704daD072;
    // sideReceiver アドレス
    address sideReceiver = 0x1431ea8af860C3862A919968C71f901aEdE1910E;
    // 分配比率
    int96 sideReceiverPortion = 40;

    // FlowSplitterのデプロイ
    FlowSplitter flowSplitter = new FlowSplitter(
      0x9Ce2062b085A2268E8d769fFC040f6692315fd2c,
      creator,
      mainReceiver,
      sideReceiver,
      sideReceiverPortion
    );

    console.log("FlowSplitter deployed at: %s", address(flowSplitter));

    vm.stopBroadcast();
  }
}
