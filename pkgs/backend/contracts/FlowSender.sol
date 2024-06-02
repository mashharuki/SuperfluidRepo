//SPDX-License-Identifier: Unlicensed
pragma solidity ^0.8.20;

import {ISuperfluid, ISuperToken} from "@superfluid-finance/ethereum-contracts/contracts/interfaces/superfluid/ISuperfluid.sol";

import {SuperTokenV1Library} from "@superfluid-finance/ethereum-contracts/contracts/apps/SuperTokenV1Library.sol";

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

// For deployment on Op Testnet

interface IFakeDAI is IERC20 {
  function mint(address account, uint256 amount) external;
}

/**
 * FlowSender Contract
 */
contract FlowSender {
  using SuperTokenV1Library for ISuperToken;

  mapping(address => bool) public accountList;

  ISuperToken public daix;

  // fDAIx address on OpSeolia = 0xd6faf98befa647403cc56bdb598690660d5257d2
  constructor(ISuperToken _daix) {
    daix = _daix;
  }

  /**
   * @dev Mints 10,000 fDAI to this contract and wraps it all into fDAIx method
   */
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
   * createStream method
   */
  function createStream(int96 flowRate, address receiver) external {
    // Create stream
    daix.createFlow(receiver, flowRate);
  }

  /**
   * @dev updates a stream from this contract to desired receiver to desired rate method
   */
  function updateStream(int96 flowRate, address receiver) external {
    // Update stream
    daix.updateFlow(receiver, flowRate);
  }

  /**
   * @dev deletes a stream from this contract to desired receiver method
   */
  function deleteStream(address receiver) external {
    // Delete stream
    daix.deleteFlow(address(this), receiver);
  }

  /**
   * @dev get flow rate between this contract to certain receiver
   */
  function readFlowRate(
    address receiver
  ) external view returns (int96 flowRate) {
    // Get flow rate
    return daix.getFlowRate(address(this), receiver);
  }
}
