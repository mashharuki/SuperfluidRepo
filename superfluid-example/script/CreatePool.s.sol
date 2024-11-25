// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Script, console} from "forge-std/Script.sol";
import {FlowSender} from "../src/FlowSender.sol";
import {ISuperToken} from "@superfluid-finance/ethereum-contracts/contracts/interfaces/superfluid/ISuperfluid.sol";
import {DistributionContract} from "../src/DistributionContract.sol";
import {PoolConfig} from "@superfluid-finance/ethereum-contracts/contracts/interfaces/agreements/gdav1/IGeneralDistributionAgreementV1.sol";

/**
 * DistributionContractコントラクトのCreatePool関数を呼び出すスクリプト
 */
contract CreatePoolScript is Script {
  function setUp() public {}

  /**
   * DistributionContractコントラクトをデプロイするスクリプト
   */
  function run() public {
    uint256 deployerPrivateKey = vm.envUint("PRIVATE_KEY");
    vm.startBroadcast(deployerPrivateKey);

    // DistributionContractインスタンスを用意する。
    DistributionContract distributionContract = DistributionContract(
      address(0x42F08AA61794dC6ebDbE7DA14d34b1BE4452f301)
    );

    console.log(
      "DistributionContract deployed at: %s",
      address(distributionContract)
    );

    // PoolConfigを用意する。
    PoolConfig memory poolConfig = PoolConfig({
      transferabilityForUnitsOwner: true,
      distributionFromAnyAddress: true
    });

    // createPool
    distributionContract.createPool(
      ISuperToken(address(0x009Ce2062b085A2268E8d769fFC040f6692315fd2c)),
      poolConfig
    );

    vm.stopBroadcast();
  }
}
