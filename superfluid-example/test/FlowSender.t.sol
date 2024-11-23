pragma solidity ^0.8.14;
import "forge-std/Test.sol";
import {ISuperfluid, ISuperToken} from "@superfluid-finance/ethereum-contracts/contracts/interfaces/superfluid/ISuperfluid.sol";
import {TestGovernance, Superfluid, ConstantFlowAgreementV1, CFAv1Library, SuperTokenFactory} from "@superfluid-finance/ethereum-contracts/contracts/utils/SuperfluidFrameworkDeploymentSteps.sol";
import {SuperfluidFrameworkDeployer} from "@superfluid-finance/ethereum-contracts/contracts/utils/SuperfluidFrameworkDeployer.sol";
import {SuperTokenV1Library} from "@superfluid-finance/ethereum-contracts/contracts/apps/SuperTokenV1Library.sol";
import {FlowSender, IFakeDAI} from "../src/FlowSender.sol";

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
    daix = ISuperToken(address(0x005eb49590d8521ca45082c5be9622bfddd1d04d7c));

    //Deploy the contract
    vm.prank(address(0x123)); // Simulate a different caller
    flowSender = new FlowSender(daix);
    vm.stopPrank(); // Restore the caller
  }
}
