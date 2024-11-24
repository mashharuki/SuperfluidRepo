//SPDX-License-Identifier: Unlicensed
pragma solidity ^0.8.26;

import {ISuperfluid, ISuperToken} from "@superfluid-finance/ethereum-contracts/contracts/interfaces/superfluid/ISuperfluid.sol";

import {SuperTokenV1Library} from "@superfluid-finance/ethereum-contracts/contracts/apps/SuperTokenV1Library.sol";

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

// For deployment on Mumbai Testnet

interface IFakeDAI is IERC20 {
  function mint(address account, uint256 amount) external;
}

/**
 * FakeDAI contract
 */
contract FakeDAI is IFakeDAI {
  string public name = "FakeDAI";
  string public symbol = "fDAI";
  uint8 public decimals = 18;

  uint256 public override totalSupply;

  mapping(address => uint256) public override balanceOf;
  mapping(address => mapping(address => uint256)) public override allowance;

  function mint(address account, uint256 amount) external override {
    totalSupply += amount;
    balanceOf[account] += amount;
  }

  function approve(
    address spender,
    uint256 amount
  ) external override returns (bool) {
    allowance[msg.sender][spender] = amount;
    return true;
  }

  function transfer(
    address recipient,
    uint256 amount
  ) external override returns (bool) {
    balanceOf[msg.sender] -= amount;
    balanceOf[recipient] += amount;
    return true;
  }

  function transferFrom(
    address sender,
    address recipient,
    uint256 amount
  ) external override returns (bool) {
    balanceOf[sender] -= amount;
    balanceOf[recipient] += amount;
    allowance[sender][msg.sender] -= amount;
    return true;
  }
}

/**
 * FlowSender contract
 */
contract FlowSender {
  using SuperTokenV1Library for ISuperToken;

  mapping(address => bool) public accountList;

  ISuperToken public daix;

  /**
   * コンストラクター
   * fDAIx address on Polygon Mumbai = 0x5D8B4C2554aeB7e86F387B4d6c00Ac33499Ed01f
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

  /// @dev creates a stream from this contract to desired receiver at desired rate
  function createStream(int96 flowRate, address receiver) external {
    // Create stream
    daix.createFlow(receiver, flowRate);
  }

  /// @dev updates a stream from this contract to desired receiver to desired rate
  function updateStream(int96 flowRate, address receiver) external {
    // Update stream
    daix.updateFlow(receiver, flowRate);
  }

  /// @dev deletes a stream from this contract to desired receiver
  function deleteStream(address receiver) external {
    // Delete stream
    daix.deleteFlow(address(this), receiver);
  }

  /// @dev get flow rate between this contract to certain receiver
  function readFlowRate(
    address receiver
  ) external view returns (int96 flowRate) {
    // Get flow rate
    return daix.getFlowRate(address(this), receiver);
  }
}
