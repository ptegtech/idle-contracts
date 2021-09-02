// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@chainlink/contracts/src/v0.8/VRFConsumerBase.sol";
import "./base/SecurityBase.sol";
import "./interface/IIdleRNG.sol";


contract IdleRNG is IIdleRNG, VRFConsumerBase, SecurityBase {
    
    bytes32 internal keyHash;
    uint256 internal fee;
    
    mapping(bytes32 => address) private _randomFroms;
    mapping(address => uint256) private _randomSeeds;
    
    event RNRequest(address from, bytes32 requestId);
    event RNResponse(address from, bytes32 requestId);
    /**
     * Constructor inherits VRFConsumerBase
     * 
     * Network: Polygon mumbai
     * Chainlink VRF Coordinator address: 0x8C7382F9D8f56b33781fE506E897a4F1e2d17255
     * LINK token address:                0x8C7382F9D8f56b33781fE506E897a4F1e2d17255
     * Key Hash: 0x6e75b569a01ef56d18cab6a8e71e6600d6ce853834d4a5748b720d06f878b3a4
     */
    constructor() VRFConsumerBase(
            0x8C7382F9D8f56b33781fE506E897a4F1e2d17255, // VRF Coordinator
            0x326C977E6efc84E512bB9C30f76E30c160eD06FB  // LINK Token
        )
    {
        keyHash = 0x6e75b569a01ef56d18cab6a8e71e6600d6ce853834d4a5748b720d06f878b3a4;
        fee = 0.0001 * 10 ** 18; // 0.0001 LINK (Varies by network)
    }
    
    /** 
     * Requests randomness 
     */
    function getRandomNumber(address from) public override {
        require(LINK.balanceOf(address(this)) >= fee, "Not enough LINK - fill contract with faucet");
        bytes32 requestId = requestRandomness(keyHash, fee);
        _randomFroms[requestId] = from;
        emit RNRequest(from, requestId);
    }

    /*
    * just for unit test must delete when deploy on mainnet
    */
    function setRandomSeed(address from, uint256 randomness) public onlyMinter override {
        _randomSeeds[from] = randomness;
    }

    /**
     * Callback function used by VRF Coordinator
     */
    function fulfillRandomness(bytes32 requestId, uint256 randomness) internal override {
        address from = _randomFroms[requestId];
        require(from != address(0), "Random request not registered");
        _randomSeeds[from] = randomness;
        emit RNResponse(from, requestId);
    }

    function expandRandomness(address from, uint256 n) public view override returns (uint256[] memory expandedValues) {
        uint256 randomness = _randomSeeds[from];
        require(randomness != 0, "Random seed not ready");
        expandedValues = new uint256[](n);
        for (uint256 i = 0; i < n; i++) {
            expandedValues[i] = uint256(keccak256(abi.encode(block.difficulty, block.timestamp, randomness, i)));
        }
        return expandedValues;
    }

    function isSeedReady(address from) public view override returns (bool) {
        return _randomSeeds[from] != 0;
    }
}
