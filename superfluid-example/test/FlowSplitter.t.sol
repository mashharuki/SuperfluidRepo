pragma solidity >=0.8.0;

import "forge-std/Test.sol";
import {ISuperfluid, ISuperToken} from "@superfluid-finance/ethereum-contracts/contracts/interfaces/superfluid/ISuperfluid.sol";
import {SuperToken} from "@superfluid-finance/ethereum-contracts/contracts/superfluid/SuperToken.sol";
import {TestGovernance, Superfluid, ConstantFlowAgreementV1, CFAv1Library, SuperTokenFactory} from "@superfluid-finance/ethereum-contracts/contracts/utils/SuperfluidFrameworkDeploymentSteps.sol";
import {SuperfluidFrameworkDeployer} from "@superfluid-finance/ethereum-contracts/contracts/utils/SuperfluidFrameworkDeployer.sol";
import {SuperTokenV1Library} from "@superfluid-finance/ethereum-contracts/contracts/apps/SuperTokenV1Library.sol";
import {FlowSplitter} from "../src/FlowSplitter.sol";
import {FlowSender, IFakeDAI, FakeDAI} from "../src/FlowSender.sol";

/**
 * FlowSplitter test Code
 */
contract FlowSplitterTest is Test {
  // Test contract instance
  FlowSplitter flowSplitter;
  // Test contract instance
  FlowSender flowSender;
  // Sepolia fork parameters
  uint256 sepoliaFork;
  // Set up your environment variables and include SEPOLIA_RPC_URL
  string SEPOLIA_RPC_URL = vm.envString("SEPOLIA_RPC_URL");
  // Super Token
  ISuperToken daix;
  // creator アドレス
  address creator = 0x51908F598A5e0d8F1A3bAbFa6DF76F9704daD072;
  // sideReceiver アドレス
  address sideReceiver = 0x1431ea8af860C3862A919968C71f901aEdE1910E;
  // 分配比率
  int96 sideReceiverPortion = 40;

  // Setup function to initialize test environment
  function setUp() public {
    //Forking and selecting the Sepolia testnet
    sepoliaFork = vm.createSelectFork(SEPOLIA_RPC_URL);

    //Pointing to the fake Daix contract on Sepolia
    //For token and protocol addresses on all networks, check out the Superfluid Explorer: https://Explorer.superfluid.finance/
    daix = ISuperToken(address(0x9Ce2062b085A2268E8d769fFC040f6692315fd2c));

    //Deploy the contract
    vm.prank(creator); // Simulate a different caller

    flowSender = new FlowSender(daix);

    // Action: Call the gainDaiX function
    flowSender.gainDaiX();

    // Assertions: Check if the contract has the expected amount of DAIx
    uint256 balance = daix.balanceOf(address(flowSender));
    assertEq(
      balance,
      10000e18,
      "The balance of DAIx should be 10,000 after gainDaiX"
    );

    // Setup: Deploy a receiver contract
    address receiver = address(0x51908F598A5e0d8F1A3bAbFa6DF76F9704daD072);
    // Setup: Define a flow rate
    int96 flowRate = 1000; // Example flow rate

    // Action: Call the createStream function
    flowSender.createStream(flowRate, receiver);
    // deploy the FlowSplitter contract
    flowSplitter = new FlowSplitter(
      address(daix),
      creator,
      creator,
      sideReceiver,
      sideReceiverPortion
    );
    vm.stopPrank(); // Restore the caller
  }

  function testGetMainAndSideReceiverFlowRates() public {
    // Get the main and side receiver flow rates
    (
      int96 mainFlowRate,
      int96 sideFlowRate,
      int96 residualFlowRate
    ) = flowSplitter.getMainAndSideReceiverFlowRates(int96(3000), int96(40));
    // Assert that the main receiver portion is 60
    assertEq(mainFlowRate, int96(2880));
    // Assert that the side receiver portion is 40
    assertEq(sideFlowRate, int96(120));
    // Assert that the residual flow rate is 0
    assertEq(residualFlowRate, int96(0));
  }
}
