// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Script, console} from "forge-std/Script.sol";
import {AdSpotContract} from "../src/AdSpotContract.sol";
// Superfluid framework interfaces we need
import {ISuperToken} from "@superfluid-finance/ethereum-contracts/contracts/interfaces/superfluid/ISuperfluid.sol";

contract AdSpotContractScript is Script {
  function setUp() public {}

  /**
   * AdSpotContractコントラクトをデプロイするスクリプト
   */
  function run() public {
    uint256 deployerPrivateKey = vm.envUint("PRIVATE_KEY");
    vm.startBroadcast(deployerPrivateKey);

    // AdSpotContractのデプロイ
    // 引数にSuperTokenのアドレスを指定
    AdSpotContract adSpotContract = new AdSpotContract(
      ISuperToken(address(0x9Ce2062b085A2268E8d769fFC040f6692315fd2c))
    );

    console.log("AdSpotContract deployed at: %s", address(adSpotContract));

    vm.stopBroadcast();
  }
}
