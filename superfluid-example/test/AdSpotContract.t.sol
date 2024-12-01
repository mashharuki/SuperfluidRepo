pragma solidity >=0.8.2 <0.9.0;

import "forge-std/Test.sol";
import {ISuperfluid, ISuperToken} from "@superfluid-finance/ethereum-contracts/contracts/interfaces/superfluid/ISuperfluid.sol";
import {TestGovernance, Superfluid, ConstantFlowAgreementV1, CFAv1Library, SuperTokenFactory} from "@superfluid-finance/ethereum-contracts/contracts/utils/SuperfluidFrameworkDeploymentSteps.sol";
import {SuperfluidFrameworkDeployer} from "@superfluid-finance/ethereum-contracts/contracts/utils/SuperfluidFrameworkDeployer.sol";
import {SuperTokenV1Library} from "@superfluid-finance/ethereum-contracts/contracts/apps/SuperTokenV1Library.sol";
import {TestToken} from "@superfluid-finance/ethereum-contracts/contracts/utils/TestToken.sol";
import {AdSpotContract} from "./../src/AdSpotContract.sol";

/**
 * AdSpotContract test code
 */
contract AdSpotContractTest is Test {
  using SuperTokenV1Library for ISuperToken;

  // Test contract instance
  AdSpotContract adSpotContract;
  //Set up your Superfluid framework
  SuperfluidFrameworkDeployer.Framework sf;
  // テスト用のアカウント
  address public account1;
  address public account2;
  // Super Token
  ISuperToken daix;
  // sepolia fork
  uint256 sepoliaFork;
  // sepolia用のRPC URLを環境変数から取得する
  string SEPOLIA_RPC_URL = vm.envString("SEPOLIA_RPC_URL");

  /**
   * テスト環境をセットアップする
   */
  function setUp() public {
    sepoliaFork = vm.createSelectFork(SEPOLIA_RPC_URL);
    // SuperTokenはあらかじめ作っておくこと！
    daix = ISuperToken(address(0x9Ce2062b085A2268E8d769fFC040f6692315fd2c));
    adSpotContract = new AdSpotContract(daix);
    account1 = address(0x51908F598A5e0d8F1A3bAbFa6DF76F9704daD072);
    account2 = address(0x1431ea8af860C3862A919968C71f901aEdE1910E);
    vm.prank(account1);
    daix.transfer(address(adSpotContract), 1e18);
    vm.stopPrank();
  }

  /**
   * テスト環境のセットアップが正常に行われたか確認する
   */
  function testInitialSetup() public {
    vm.selectFork(sepoliaFork);
    assertEq(vm.activeFork(), sepoliaFork);
    assertEq(
      address(adSpotContract.getAcceptedToken()),
      address(daix),
      "Accepted token should be daix"
    );
    assertEq(
      adSpotContract.getOwner(),
      address(this),
      "Contract owner should be this contract"
    );
    assertEq(
      adSpotContract.getHighestBidder(),
      address(0),
      "Initial highest bidder should be address 0"
    );
  }

  /**
   * フローの作成が正常に行われるか確認する
   */
  function testFlowCreation() public {
    int96 flowRate = int96(1000); // example flow rate

    // Create a flow from account1 to the adSpotContract
    vm.startPrank(account1);
    daix.createFlow(address(adSpotContract), flowRate);
    vm.stopPrank();

    // Verify that the highest bidder and flow rate are updated correctly
    assertEq(
      adSpotContract.getHighestFlowRate(),
      flowRate,
      "Highest flow rate should match the set flow rate"
    );
    assertEq(
      adSpotContract.getHighestBidder(),
      account1,
      "Account1 should be the highest bidder"
    );
  }

  /**
   * フローの更新が正常に行われるか確認する
   */
  function testFlowUpdate() public {
    int96 flowRate = int96(1000); // example flow rate

    // Create a flow from account1 to the adSpotContract
    vm.startPrank(account1);
    daix.createFlow(address(adSpotContract), flowRate);
    vm.stopPrank();

    // Verify that the highest bidder and flow rate are updated correctly
    assertEq(
      adSpotContract.getHighestBidder(),
      account1,
      "Account1 should be the highest bidder"
    );
    assertEq(
      adSpotContract.getHighestFlowRate(),
      flowRate,
      "Highest flow rate should match the set flow rate"
    );

    // Update the flow rate
    vm.startPrank(account1);
    daix.updateFlow(address(adSpotContract), 2 * flowRate);
    vm.stopPrank();

    // Verify that the flow rate is updated correctly
    assertEq(
      adSpotContract.getHighestFlowRate(),
      2 * flowRate,
      "Highest flow rate should match the set flow rate"
    );
  }

  /**
   * フローの削除が正常に行われるか確認する
   */
  function testFlowDeletion() public {
    int96 flowRate = int96(1000); // example flow rate

    // Create a flow from account1 to the adSpotContract
    vm.startPrank(account1);
    daix.createFlow(address(adSpotContract), flowRate);
    vm.stopPrank();

    // Verify that the highest bidder and flow rate are updated correctly
    assertEq(
      adSpotContract.getHighestBidder(),
      account1,
      "Account1 should be the highest bidder"
    );
    assertEq(
      adSpotContract.getHighestFlowRate(),
      flowRate,
      "Highest flow rate should match the set flow rate"
    );

    // フローを削除する。
    vm.startPrank(account1);
    daix.deleteFlow(account1, address(adSpotContract));
    vm.stopPrank();

    // Verify that the highest bidder and flow rate are updated correctly
    assertEq(
      adSpotContract.getHighestBidder(),
      address(0),
      "Initial highest bidder should be address 0"
    );
    assertEq(
      adSpotContract.getHighestFlowRate(),
      0,
      "Highest flow rate should match the set flow rate"
    );
  }

  /**
   * フローの作成が正常に行われるか確認する
   */
  function testHigherBidd() public {
    int96 flowRate = int96(1000); // example flow rate

    // Create a flow from account1 to the adSpotContract
    vm.startPrank(account1);
    daix.createFlow(address(adSpotContract), flowRate);
    vm.stopPrank();

    // Verify that the highest bidder and flow rate are updated correctly
    assertEq(
      adSpotContract.getHighestBidder(),
      account1,
      "Account1 should be the highest bidder"
    );
    assertEq(
      adSpotContract.getHighestFlowRate(),
      flowRate,
      "Highest flow rate should match the set flow rate"
    );

    // Create a flow from account2 to the adSpotContract
    vm.startPrank(account2);
    daix.createFlow(address(adSpotContract), flowRate + 2);
    vm.stopPrank();

    // Verify that the highest bidder and flow rate are updated correctly
    assertEq(
      adSpotContract.getHighestBidder(),
      account2,
      "Account2 should be the highest bidder"
    );
    assertEq(
      adSpotContract.getHighestFlowRate(),
      flowRate + 2,
      "Highest flow rate should match the set flow rate"
    );
  }

  /**
   * NFTの設定が正常に行われるか確認する
   */
  function testNFTSetting() public {
    int96 flowRate = int96(1000); // example flow rate

    // Create a flow from account1 to the adSpotContract
    vm.startPrank(account1);
    daix.createFlow(address(adSpotContract), flowRate);
    vm.stopPrank();

    // Verify that the highest bidder and flow rate are updated correctly
    assertEq(
      adSpotContract.getHighestBidder(),
      account1,
      "Account1 should be the highest bidder"
    );
    assertEq(
      adSpotContract.getHighestFlowRate(),
      flowRate,
      "Highest flow rate should match the set flow rate"
    );

    // Set an NFT to showcase
    vm.startPrank(account1);
    adSpotContract.setNftToShowcase(address(this), 1);
    vm.stopPrank();

    // Verify that the NFT address and token ID are updated correctly
    assertEq(
      adSpotContract.getNftAddress(),
      address(this),
      "NFT address should be this contract"
    );
    assertEq(adSpotContract.getNftTokenId(), 1, "NFT token ID should be 1");
  }

  /**
   * オーナーの単位が正常に設定されるか確認する
   */
  function testOwnerUnitsFirstTime() public {
    int96 flowRate = int96(1000); // example flow rate

    // Create a flow from account1 to the adSpotContract
    vm.startPrank(account1);
    daix.createFlow(address(adSpotContract), flowRate);
    vm.stopPrank();

    // Verify that the highest bidder and flow rate are updated correctly
    assertEq(
      adSpotContract.getHighestBidder(),
      account1,
      "Account1 should be the highest bidder"
    );
    assertEq(
      adSpotContract.getHighestFlowRate(),
      flowRate,
      "Highest flow rate should match the set flow rate"
    );

    // Verify that the owner's shares are updated correctly
    assertEq(
      adSpotContract.getOwnerShares(),
      1,
      "Owner's shares should be 1e18"
    );
  }

  /**
   * メンバーの単位が正常に設定されるか確認する
   */
  function testMembersUnits() public {
    int96 flowRate = int96(1000); // example flow rate

    // Create a flow from account1 to the adSpotContract
    vm.startPrank(account1);
    daix.createFlow(address(adSpotContract), flowRate);
    vm.stopPrank();

    // Verify that the highest bidder and flow rate are updated correctly
    assertEq(
      adSpotContract.getHighestBidder(),
      account1,
      "Account1 should be the highest bidder"
    );
    assertEq(
      adSpotContract.getHighestFlowRate(),
      flowRate,
      "Highest flow rate should match the set flow rate"
    );

    // Verify that the owner's shares are updated correctly
    assertEq(adSpotContract.getOwnerShares(), 1, "Owner's shares should be 1");

    // Create a flow from account2 to the adSpotContract
    vm.startPrank(account2);
    daix.createFlow(address(adSpotContract), flowRate + 2);
    vm.stopPrank();

    // Verify that the owner's shares are updated correctly
    assertEq(
      adSpotContract.getOwnerShares(),
      adSpotContract.getTotalShares() / 2,
      "Owner's shares should be half of total shares"
    );
    assertEq(
      adSpotContract.getOwnerShares(),
      adSpotContract.getMemberShares(account1),
      "Owner's shares should be same as account1's shares"
    );
  }

  /**
   * オーナーの単位が正常に設定されるか確認する
   */
  function testAdvancedMembersUnits() public {
    int96 flowRate = int96(1000); // example flow rate

    // Create a flow from account1 to the adSpotContract
    vm.startPrank(account1);
    daix.createFlow(address(adSpotContract), flowRate);
    vm.stopPrank();

    // Verify that the highest bidder and flow rate are updated correctly
    assertEq(
      adSpotContract.getHighestBidder(),
      account1,
      "Account1 should be the highest bidder"
    );
    assertEq(
      adSpotContract.getHighestFlowRate(),
      flowRate,
      "Highest flow rate should match the set flow rate"
    );

    // Verify that the owner's shares are updated correctly
    assertEq(adSpotContract.getOwnerShares(), 1, "Owner's shares should be 1");

    // Create a flow from account2 to the adSpotContract
    vm.startPrank(account2);
    daix.createFlow(address(adSpotContract), flowRate + 2);
    vm.stopPrank();

    // Verify that the owner's shares are updated correctly
    assertEq(
      adSpotContract.getOwnerShares(),
      adSpotContract.getTotalShares() / 2,
      "Owner's shares should be half of total shares"
    );
    assertEq(
      adSpotContract.getOwnerShares(),
      adSpotContract.getMemberShares(account1),
      "Owner's shares should be same as account1's shares"
    );

    // Create a flow from account2 to the adSpotContract
    vm.startPrank(account1);
    daix.createFlow(address(adSpotContract), flowRate + 4);
    vm.stopPrank();

    // Verify that the owner's shares are updated correctly
    assertEq(
      adSpotContract.getOwnerShares(),
      adSpotContract.getTotalShares() / 2,
      "Owner's shares should be 1/3 of total shares"
    );
    assertEq(
      adSpotContract.getMemberShares(account1) +
        adSpotContract.getMemberShares(account2),
      adSpotContract.getTotalShares() / 2,
      "Owner's shares should be 1/3 of total shares"
    );
  }
}
