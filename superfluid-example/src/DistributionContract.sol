//SPDX-License-Identifier: Unlicensed
pragma solidity >=0.8.14;

import {ISuperfluid, ISuperToken, ISuperfluidToken} from "@superfluid-finance/ethereum-contracts/contracts/interfaces/superfluid/ISuperfluid.sol";
import {SuperTokenV1Library} from "@superfluid-finance/ethereum-contracts/contracts/apps/SuperTokenV1Library.sol";
import {IGeneralDistributionAgreementV1, ISuperfluidPool, PoolConfig} from "@superfluid-finance/ethereum-contracts/contracts/interfaces/agreements/gdav1/IGeneralDistributionAgreementV1.sol";
import {IFakeDAI} from "./FlowSender.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

/**
 * DistributionContract
 */
contract DistributionContract {
  using SuperTokenV1Library for ISuperToken;

  mapping(address => bool) public accountList;

  ISuperToken public daix;

  ISuperfluidPool pool;

  /**
   * コンストラクター
   */
  constructor(ISuperToken _daix) {
    daix = _daix;
  }

  /// @dev Mints 10,000 fDAI to this contract and wraps it all into fDAIx
  function gainDaiX() external {
    // Get address of fDAI by getting underlying token address from DAIx token
    IFakeDAI fdai = IFakeDAI(daix.getUnderlyingToken());

    // Mint 10,000 fDAI
    fdai.mint(address(this), 10000e18);

    // Approve fDAIx contract to spend fDAI
    fdai.approve(address(daix), 20000e18);

    // Wrap the fDAI into fDAIx
    daix.upgrade(10000e18);
  }

  /**
   * creates a Pool with this contract being the admin
   */
  function createPool(
    ISuperToken token,
    PoolConfig memory poolConfig
  ) external {
    // Create Pool
    pool = daix.createPool(address(this), poolConfig);
  }

  /**
   * updates Units for a specific member
   */
  function updateMemberUnits(address memberAddress, uint128 newUnits) external {
    // Update member units
    daix.updateMemberUnits(pool, memberAddress, newUnits);
  }

  /**
   * creates a stream from this contract to the pool
   */
  function createStreamToPool(address receiver, int96 flowRate) external {
    // Create stream
    daix.createFlow(receiver, flowRate);
  }

  /**
   * 分配する
   */
  function distribute(uint256 amount) public {
    daix.distributeToPool(address(this), pool, amount);
  }

  /**
   * 分配するフローを設定する
   */
  function distributeFlow(int96 flowRate) public {
    daix.distributeFlow(address(this), pool, flowRate);
  }
}
