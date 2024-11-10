// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.26;

import {Test} from "forge-std/Test.sol";
import {ISuperToken} from "@superfluid-finance/ethereum-contracts/contracts/interfaces/superfluid/ISuperfluid.sol";
import {SuperfluidFrameworkDeployer} from "@superfluid-finance/ethereum-contracts/contracts/utils/SuperfluidFrameworkDeployer.sol";
import {ERC1820RegistryCompiled} from "@superfluid-finance/ethereum-contracts/contracts/libs/ERC1820RegistryCompiled.sol";
import {PureSuperToken} from "./../src/PureSuperToken.sol";

/**
 * PureSuperToken コントラクト用のテストコード
 */
contract PureSuperTokenProxyTest is Test {
  address internal constant _OWNER = address(0x1);
  address internal constant _TESTWALLET = address(0x2);

  PureSuperToken internal _superTokenProxy;
  SuperfluidFrameworkDeployer.Framework internal _sf;

  function setUp() public {
    vm.etch(ERC1820RegistryCompiled.at, ERC1820RegistryCompiled.bin);
    SuperfluidFrameworkDeployer sfDeployer = new SuperfluidFrameworkDeployer();
    sfDeployer.deployTestFramework();
    _sf = sfDeployer.getFramework();
  }

  function testDeploy() public {
    _superTokenProxy = new PureSuperToken();
    assert(address(_superTokenProxy) != address(0));
  }

  /**
   * 1000トークン発行してみるテストコード
   */
  function testSuperTokenBalance() public {
    _superTokenProxy = new PureSuperToken();
    _superTokenProxy.initialize(
      _sf.superTokenFactory,
      "TestToken",
      "TST",
      _OWNER,
      1000
    );
    ISuperToken superToken = ISuperToken(address(_superTokenProxy));
    uint balance = superToken.balanceOf(_OWNER);
    assert(balance == 1000);

    // 名前やシンボルを確認
    string memory name = superToken.name();
    string memory symbol = superToken.symbol();
    assertEq(name, "TestToken");
    assertEq(symbol, "TST");
  }
}
