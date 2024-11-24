pragma solidity >=0.8.14;
import "forge-std/Test.sol";
import {ISuperfluid, ISuperToken, PoolConfig, ISuperfluidPool} from "@superfluid-finance/ethereum-contracts/contracts/interfaces/superfluid/ISuperfluid.sol";
import {TestGovernance, Superfluid, ConstantFlowAgreementV1, CFAv1Library, SuperTokenFactory} from "@superfluid-finance/ethereum-contracts/contracts/utils/SuperfluidFrameworkDeploymentSteps.sol";
import {SuperfluidFrameworkDeployer} from "@superfluid-finance/ethereum-contracts/contracts/utils/SuperfluidFrameworkDeployer.sol";
import {SuperTokenV1Library} from "@superfluid-finance/ethereum-contracts/contracts/apps/SuperTokenV1Library.sol";
import {DistributionContract} from "../src/DistributionContract.sol";

/**
 * DistributionContractTest
 */
contract DistributionContractTest is Test {
  // Test contract instance
  DistributionContract distributionContract;
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

    //Pointing to the fake Daix contract on Mumbai
    //For token and protocol addresses on all networks, check out the Superfluid Explorer: https://Explorer.superfluid.finance/
    daix = ISuperToken(address(0x9Ce2062b085A2268E8d769fFC040f6692315fd2c));

    //Deploy the contract
    vm.prank(address(0x51908F598A5e0d8F1A3bAbFa6DF76F9704daD072));
    // DistributionContractをデプロイする。
    distributionContract = new DistributionContract(ISuperToken(address(daix)));
    vm.stopPrank();
  }

  function testGainDaiX() public {
    // Action: Call the gainDaiX function
    distributionContract.gainDaiX();

    // Assertions: Check if the contract has the expected amount of fDAIx
    uint256 balance = daix.balanceOf(address(distributionContract));
    assertEq(
      balance,
      10000e18,
      "The balance of fDAIx should be 10,000 after gainDaiX"
    );
  }

  function testCreatePool() public {
    // Define pool configuration
    PoolConfig memory poolConfig;
    // Set poolConfig parameters...

    // Action: Call the createPool function
    distributionContract.createPool(daix, poolConfig);
  }

  function testUpdateMemberUnits() public {
    // Define pool configuration
    PoolConfig memory poolConfig;
    // Set poolConfig parameters...

    // Action: Call the createPool function
    distributionContract.createPool(daix, poolConfig);
    // memberAddressを設定する。
    address memberAddress = address(0x1431ea8af860C3862A919968C71f901aEdE1910E);

    // Action: Update member units
    uint128 newUnits = 100;
    distributionContract.updateMemberUnits(memberAddress, newUnits);
  }

  function testCreateStreamToPool() public {
    // Action: Call the gainDaiX function
    distributionContract.gainDaiX();
    // Define pool configuration
    PoolConfig memory poolConfig;
    // Set poolConfig parameters...

    // Action: Call the createPool function
    distributionContract.createPool(daix, poolConfig);

    // receiverを設定する。
    address receiver = address(0x1431ea8af860C3862A919968C71f901aEdE1910E);
    // Action: Create a stream to the pool
    int96 flowRate = 1000;
    distributionContract.createStreamToPool(receiver, flowRate);
  }
}
