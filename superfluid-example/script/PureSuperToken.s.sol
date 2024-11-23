// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Script} from "forge-std/Script.sol";
import {PureSuperToken} from "./../src/PureSuperToken.sol";
import {Upgrades} from "openzeppelin-foundry-upgrades/Upgrades.sol";
import {ISuperTokenFactory} from
    "@superfluid-finance/ethereum-contracts/contracts/interfaces/superfluid/ISuperfluid.sol";
import {console} from "forge-std/console.sol";

/**
 * PureSuperTokenデプロイ用のスクリプト
 */
contract PureSuperTokenProxyScript is Script {
    function run() external {
        uint256 deployerPrivateKey = vm.envUint("PRIVATE_KEY");
        vm.startBroadcast(deployerPrivateKey);
        // PureSuperTokenProxyのデプロイ
        address proxy = Upgrades.deployUUPSProxy(
            "PureSuperToken.sol",
            abi.encodeCall(
                PureSuperToken.initialize,
                (
                    ISuperTokenFactory(0x254C2e152E8602839D288A7bccdf3d0974597193),
                    "Super Fake Token2",
                    "SFT2x",
                    0x51908F598A5e0d8F1A3bAbFa6DF76F9704daD072,
                    100000000000000000000
                )
            )
        );

        console.log("PureSuperTokenProxy deployed at: %s", proxy);

        vm.stopBroadcast();
    }
}
