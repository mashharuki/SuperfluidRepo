// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Script, console} from "forge-std/Script.sol";
import {Counter} from "../src/Counter.sol";

contract CounterScript is Script {
  function setUp() public {}

  /**
   * Counterコントラクトをデプロイするスクリプト
   */
  function run() public {
    uint256 deployerPrivateKey = vm.envUint("PRIVATE_KEY");
    vm.startBroadcast(deployerPrivateKey);

    // Counterのデプロイ
    Counter counter = new Counter();

    console.log("Counter deployed at: %s", address(counter));

    vm.stopBroadcast();
  }
}
