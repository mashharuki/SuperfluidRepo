pragma solidity ^0.8.14;

import "forge-std/Test.sol";
import {ISuperfluid, ISuperToken} from "@superfluid-finance/ethereum-contracts/contracts/interfaces/superfluid/ISuperfluid.sol";
import {SuperToken} from "@superfluid-finance/ethereum-contracts/contracts/superfluid/SuperToken.sol";
import {TestGovernance, Superfluid, ConstantFlowAgreementV1, CFAv1Library, SuperTokenFactory} from "@superfluid-finance/ethereum-contracts/contracts/utils/SuperfluidFrameworkDeploymentSteps.sol";
import {SuperfluidFrameworkDeployer} from "@superfluid-finance/ethereum-contracts/contracts/utils/SuperfluidFrameworkDeployer.sol";
import {SuperTokenV1Library} from "@superfluid-finance/ethereum-contracts/contracts/apps/SuperTokenV1Library.sol";
import {FlowSender, IFakeDAI, FakeDAI} from "../src/FlowSender.sol";

/**
 * FlowSender test Code
 */
contract FlowSenderTest is Test {
  // Test contract instance
  FlowSender flowSender;
  // Sepolia fork parameters
  uint256 sepoliaFork;
  // Set up your environment variables and include SEPOLIA_RPC_URL
  string SEPOLIA_RPC_URL = vm.envString("SEPOLIA_RPC_URL");
  // Super Token
  ISuperToken daix;

  // Setup function to initialize test environment
  function setUp() public {
    //Forking and selecting the Sepolia testnet
    sepoliaFork = vm.createSelectFork(SEPOLIA_RPC_URL);

    //Pointing to the fake Daix contract on Sepolia
    //For token and protocol addresses on all networks, check out the Superfluid Explorer: https://Explorer.superfluid.finance/
    daix = ISuperToken(address(0x9Ce2062b085A2268E8d769fFC040f6692315fd2c));

    //Deploy the contract
    vm.prank(address(0x123)); // Simulate a different caller
    flowSender = new FlowSender(daix);
    vm.stopPrank(); // Restore the caller
  }

  function testGainDaiX() external {
    // Get address of fDAI by getting underlying token address from DAIx token
    IFakeDAI fdai = IFakeDAI(daix.getUnderlyingToken());

    // Mint 10,000 fDAI
    fdai.mint(address(this), 10000e18);

    // Approve fDAIx contract to spend fDAI
    fdai.approve(address(daix), 20000e18);

    // Wrap the fDAI into fDAIx
    daix.upgrade(10000e18);
  }

  function testGainDaiX2() public {
    // Action: Call the gainDaiX function
    flowSender.gainDaiX();

    // Assertions: Check if the contract has the expected amount of DAIx
    uint256 balance = daix.balanceOf(address(flowSender));
    assertEq(
      balance,
      10000e18,
      "The balance of DAIx should be 10,000 after gainDaiX"
    );
  }

  function testCreateStream() public {
    // Setup: Deploy a receiver contract
    address receiver = address(0x51908F598A5e0d8F1A3bAbFa6DF76F9704daD072);

    // Setup: Define a flow rate
    int96 flowRate = 1000; // Example flow rate

    // Action: Call the gainDaiX function
    flowSender.gainDaiX();

    // Action: Call the createStream function
    flowSender.createStream(flowRate, receiver);

    // Assertions: Verify if the stream is created with correct parameters
    int96 outFlowRate = flowSender.readFlowRate(receiver);

    assertEq(
      outFlowRate,
      flowRate,
      "The flow rate should match the specified rate"
    );
  }

  function testUpdateStream() public {
    // Setup: Deploy a receiver contract
    address receiver = address(0x51908F598A5e0d8F1A3bAbFa6DF76F9704daD072);

    // Setup: Define a flow rate
    int96 flowRate = 1000; // Example flow rate

    // Action: Call the gainDaiX function
    flowSender.gainDaiX();

    // Action: Call the createStream function
    flowSender.createStream(flowRate, receiver);

    // Assertions: Verify if the stream is created with correct parameters
    int96 outFlowRate = flowSender.readFlowRate(receiver);

    assertEq(
      outFlowRate,
      flowRate,
      "The flow rate should match the specified rate"
    );

    int96 updateFlowRate = 2000;

    // update the stream
    flowSender.updateStream(updateFlowRate, receiver);

    // Assertions: Verify if the stream is created with correct parameters
    int96 outFlowRate2 = flowSender.readFlowRate(receiver);

    assertEq(
      outFlowRate2,
      updateFlowRate,
      "The flow rate should match the specified rate"
    );
  }

  function testDeleteStream() public {
    // Setup: Deploy a receiver contract
    address receiver = address(0x51908F598A5e0d8F1A3bAbFa6DF76F9704daD072);

    // Action: Call the gainDaiX function
    flowSender.gainDaiX();
    // Setup: Create a stream first
    flowSender.createStream(1000, receiver);

    // Action: Attempt to delete a stream with the correct permission
    flowSender.deleteStream(receiver);

    // Assertions: Verify if the stream is created with correct parameters
    int96 outFlowRate = flowSender.readFlowRate(receiver);

    assertEq(outFlowRate, 0, "The flow rate should match the specified rate");
  }
}
