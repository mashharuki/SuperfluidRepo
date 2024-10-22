pragma solidity ^0.8.14;
import "forge-std/Test.sol";
import {ISuperfluid} from "@superfluid-finance/ethereum-contracts/contracts/interfaces/superfluid/ISuperfluid.sol";
import {SuperfluidFrameworkDeployer, TestGovernance, Superfluid, ConstantFlowAgreementV1, CFAv1Library, SuperTokenFactory} from "@superfluid-finance/ethereum-contracts/contracts/utils/SuperfluidFrameworkDeployer.sol";

contract DistributionContractTest is Test {
  // Test contract instance
  DistributionContract distributionContract;
  //Set up your Superfluid framework
  struct Framework {
    TestGovernance governance;
    Superfluid host;
    ConstantFlowAgreementV1 cfa;
    CFAv1Library.InitData cfaLib;
    InstantDistributionAgreementV1 ida;
    IDAv1Library.InitData idaLib;
    SuperTokenFactory superTokenFactory;
  }

  SuperfluidFrameworkDeployer.Framework sf;

  // Setup function to initialize test environment
  function setUp() public {
    address owner;
    //DEPLOYING THE FRAMEWORK
    SuperfluidFrameworkDeployer sfDeployer = new SuperfluidFrameworkDeployer();
    sfDeployer.deployFramework();
    sf = sfDeployer.getFramework();

    // DEPLOYING DAI and DAI wrapper super token

    ISuperToken daix = sfDeployer.deployWrapperToken(
      "Fake DAI",
      "DAI",
      18,
      10000000000000
    );

    // Deploy your contract here
    distributionContract = new DistributionContract(daix);
  }
}
