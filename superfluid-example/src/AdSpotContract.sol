// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.8.2 <0.9.0;

/**
 * @title Storage
 * @dev Store & retrieve value in a variable
 * @custom:dev-run-script ./scripts/deploy_with_ethers.ts
 */
import {ISuperfluid, ISuperToken, ISuperApp, SuperAppDefinitions} from "@superfluid-finance/ethereum-contracts/contracts/interfaces/superfluid/ISuperfluid.sol";
import {ISuperfluidPool} from "@superfluid-finance/ethereum-contracts/contracts/interfaces/agreements/gdav1/ISuperfluidPool.sol";
import {SuperTokenV1Library} from "@superfluid-finance/ethereum-contracts/contracts/apps/SuperTokenV1Library.sol";
import {CFASuperAppBase} from "@superfluid-finance/ethereum-contracts/contracts/apps/CFASuperAppBase.sol";
import {IGeneralDistributionAgreementV1, ISuperfluidPool, PoolConfig} from "@superfluid-finance/ethereum-contracts/contracts/interfaces/agreements/gdav1/IGeneralDistributionAgreementV1.sol";

/**
 * Sample AdSpot Contract
 */
contract AdSpotContract is CFASuperAppBase {
  using SuperTokenV1Library for ISuperToken;

  uint256 private number;
  address private poolAddress;
  ISuperfluidPool pool;
  ISuperToken acceptedToken;
  address private owner;
  address public highestBidder;
  int96 private highestFlowRate;
  uint256 private lastUpdate;
  PoolConfig private poolConfig;
  address public nftAddress;
  uint256 public nftTokenId;

  event newHighestBidder(address highestBidder, int96 flowRate);
  event NftToShowcaseSet(address nftAddress, uint256 tokenId);

  /*
   * @dev Constructor to initialize the contract with necessary Superfluid interfaces and parameters.
   * @param _acceptedToken The SuperToken accepted for streaming payments.
   */

  constructor(
    ISuperToken _acceptedToken
  ) CFASuperAppBase(ISuperfluid(ISuperToken(_acceptedToken).getHost())) {
    acceptedToken = _acceptedToken;
    owner = msg.sender;
    poolConfig.transferabilityForUnitsOwner = true;
    poolConfig.distributionFromAnyAddress = true;
    pool = SuperTokenV1Library.createPool(
      acceptedToken,
      address(this),
      poolConfig
    );
    poolAddress = address(pool);
    pool.updateMemberUnits(owner, 1);
    highestFlowRate = acceptedToken.getFlowRate(owner, address(this));
    lastUpdate = block.timestamp;
    highestBidder = address(0);
  }

  function isAcceptedSuperToken(
    ISuperToken superToken
  ) public view override returns (bool) {
    return superToken == acceptedToken;
  }

  /*
   * @dev Allows the highest bidder to set an NFT to showcase.
   * @param _nftAddress The address of the NFT contract.
   * @param _tokenId The token ID of the NFT.
   */

  function setNftToShowcase(address _nftAddress, uint256 _tokenId) external {
    require(
      msg.sender == highestBidder,
      "Only the highest bidder can set the NFT"
    );
    nftAddress = _nftAddress;
    nftTokenId = _tokenId;
    emit NftToShowcaseSet(_nftAddress, _tokenId);
  }

  // ---------------------------------------------------------------------------------------------
  // Getters
  // ---------------------------------------------------------------------------------------------

  /**
   * @dev Returns the address of the pool.
   */
  function getPoolAddress() public view returns (address) {
    return poolAddress;
  }

  /**
   * @dev Returns the accepted token for streaming payments.
   */
  function getAcceptedToken() public view returns (ISuperToken) {
    return acceptedToken;
  }

  /**
   * @dev Returns the address of the contract owner.
   */
  function getOwner() public view returns (address) {
    return owner;
  }

  /**
   * @dev Returns the address of the highest bidder.
   */
  function getHighestBidder() public view returns (address) {
    return highestBidder;
  }

  /**
   * @dev Returns the highest flow rate.
   */
  function getHighestFlowRate() public view returns (int96) {
    return highestFlowRate;
  }

  /**
   * @dev Returns the last update timestamp.
   */
  function getLastUpdate() public view returns (uint256) {
    return lastUpdate;
  }

  /**
   * @dev Returns owner's shares.
   */
  function getOwnerShares() public view returns (uint128) {
    return pool.getUnits(owner);
  }

  /**
   * @dev Returns shares of the highest bidder.
   */
  function getBidderShares() public view returns (uint128) {
    return pool.getUnits(highestBidder);
  }

  /**
   * @dev Returns the shares of an address.
   * @param memberAddress The address to check.
   */
  function getMemberShares(
    address memberAddress
  ) public view returns (uint128) {
    return pool.getUnits(memberAddress);
  }

  /**
   * @dev Returns the total shares.
   */
  function getTotalShares() public view returns (uint128) {
    return pool.getTotalUnits();
  }

  /**
   * @dev Returns the NFT address.
   */
  function getNftAddress() public view returns (address) {
    return nftAddress;
  }

  /**
   * @dev Returns the NFT token ID.
   */
  function getNftTokenId() public view returns (uint256) {
    return nftTokenId;
  }

  // ---------------------------------------------------------------------------------------------
  // SUPER APP CALLBACKS
  // ---------------------------------------------------------------------------------------------

  /*
   * @dev Callback function that gets executed when a new flow is created to this contract.
   *      It handles logic for updating the highest bidder and distributing shares.
   * @param sender The address of the sender creating the flow.
   * @param ctx The context of the current flow transaction.
   * @return bytes Returns the new transaction context.
   */
  function onFlowCreated(
    ISuperToken,
    /*superToken*/ address sender,
    bytes calldata ctx
  ) internal override returns (bytes memory newCtx) {
    int96 senderFlowRate = acceptedToken.getFlowRate(sender, address(this));
    require(
      senderFlowRate > highestFlowRate,
      "Sender flowrate lower than current flowRate"
    );
    newCtx = ctx;
    if (highestBidder != address(0)) {
      newCtx = acceptedToken.deleteFlowWithCtx(
        highestBidder,
        address(this),
        ctx
      );
      uint128 halfShares = uint128(block.timestamp - lastUpdate) / 2;
      if (pool.getUnits(owner) == 1) {
        pool.updateMemberUnits(owner, halfShares + pool.getUnits(owner) - 1);
      } else {
        pool.updateMemberUnits(owner, halfShares + pool.getUnits(owner));
      }
      pool.updateMemberUnits(
        highestBidder,
        halfShares + pool.getUnits(highestBidder)
      );
    }
    newCtx = acceptedToken.distributeFlowWithCtx(
      address(this),
      pool,
      senderFlowRate,
      newCtx
    );
    highestBidder = sender;
    highestFlowRate = senderFlowRate;
    lastUpdate = block.timestamp;
    emit newHighestBidder(highestBidder, highestFlowRate);
    return newCtx;
  }

  /*
   * @dev Callback function that gets executed when an existing flow to this contract is updated.
   *      It updates the highest bidder and adjusts share distribution accordingly.
   * @param sender The address of the sender updating the flow.
   * @param previousflowRate The previous flow rate before the update.
   * @param lastUpdated The timestamp of the last update.
   * @param ctx The context of the current flow transaction.
   * @return bytes Returns the new transaction context.
   */
  function onFlowUpdated(
    ISuperToken,
    address sender,
    int96 previousflowRate,
    uint256 lastUpdated,
    bytes calldata ctx
  ) internal override returns (bytes memory newCtx) {
    int96 senderFlowRate = acceptedToken.getFlowRate(sender, address(this));
    require(
      senderFlowRate > previousflowRate,
      "Sender flowRate is lower than the previous one, delete flowrate and start a new one lower"
    );
    require(
      senderFlowRate > highestFlowRate,
      "You already have a flowrate that is higher than this one"
    );
    newCtx = ctx;
    uint128 halfShares = uint128(block.timestamp - lastUpdate) / 2;
    ISuperfluidPool(poolAddress).updateMemberUnits(
      owner,
      halfShares + pool.getUnits(owner)
    );
    ISuperfluidPool(poolAddress).updateMemberUnits(
      highestBidder,
      halfShares + pool.getUnits(highestBidder)
    );
    newCtx = acceptedToken.distributeFlowWithCtx(
      address(this),
      pool,
      senderFlowRate,
      newCtx
    );
    highestBidder = sender;
    highestFlowRate = senderFlowRate;
    lastUpdate = block.timestamp;
    emit newHighestBidder(highestBidder, highestFlowRate);
    return newCtx;
  }

  /*
   * @dev Callback function that gets executed when a flow to this contract is deleted.
   *      Handles the removal of a bidder and adjustment of shares.
   * @param sender The address of the sender deleting the flow.
   * @param ctx The context of the current flow transaction.
   * @return bytes Returns the new transaction context.
   */

  function onFlowDeleted(
    ISuperToken /*superToken*/,
    address sender,
    address /*receiver*/,
    int96 previousFlowRate,
    uint256 /*lastUpdated*/,
    bytes calldata ctx
  ) internal override returns (bytes memory newCtx) {
    require(sender == highestBidder, "You don't have an active stream");

    uint128 halfShares = uint128(block.timestamp - lastUpdate) / 2;
    pool.updateMemberUnits(owner, halfShares + pool.getUnits(owner));
    pool.updateMemberUnits(
      highestBidder,
      halfShares + pool.getUnits(highestBidder)
    );

    newCtx = acceptedToken.distributeFlowWithCtx(address(this), pool, 0, ctx);
    highestBidder = address(0);
    highestFlowRate = 0;
    lastUpdate = block.timestamp;
    emit newHighestBidder(highestBidder, highestFlowRate);
    return newCtx;
  }

  /**
   * @dev creates a stream from this contract to desired receiver at desired rate
   */
  function createStream(int96 flowRate, address receiver) external {
    // Create stream
    acceptedToken.createFlow(receiver, flowRate);
  }

  /**
   * @dev updates a stream from this contract to desired receiver to desired rate
   */
  function updateStream(int96 flowRate, address receiver) external {
    // Update stream
    acceptedToken.updateFlow(receiver, flowRate);
  }

  /**
   * @dev deletes a stream from this contract to desired receiver
   */
  function deleteStream(address receiver) external {
    // Delete stream
    acceptedToken.deleteFlow(address(this), receiver);
  }

  /**
   * @dev get flow rate between this contract to certain receiver
   */
  function readFlowRate(
    address receiver
  ) external view returns (int96 flowRate) {
    // Get flow rate
    return acceptedToken.getFlowRate(address(this), receiver);
  }

  /**
   * updates Units for a specific member
   */
  function updateMemberUnits(address memberAddress, uint128 newUnits) external {
    // Update member units
    acceptedToken.updateMemberUnits(pool, memberAddress, newUnits);
  }

  /**
   * 分配する
   */
  function distribute(uint256 amount) public {
    acceptedToken.distributeToPool(address(this), pool, amount);
  }

  /**
   * 分配するフローを設定する
   */
  function distributeFlow(int96 flowRate) public {
    acceptedToken.distributeFlow(address(this), pool, flowRate);
  }
}
