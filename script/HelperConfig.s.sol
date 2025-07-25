// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity ^0.8.30;

import {Script} from "forge-std/Script.sol";
import {MockV3Aggregator} from "../test/mocks/MockV3Aggregator.sol";

contract HelperConfig is Script {
    uint8 public constant DECIMALS = 8;
    int256 public constant INITIAL_PRICE = 2000e8;
    NetworkConfig public activeNetworkConfig;
    struct NetworkConfig {
        address priceFeed;
    }
    constructor() {
        if (block.chainid == 11155111) {
            // Sepolia
            activeNetworkConfig = GetSepoliaEthConfig();
        } else if (block.chainid == 31337) {
            // Anvil
            activeNetworkConfig = GetAnvilEthConfig();
        } else {
            revert("Unsupported network");
        }
    }
    function GetSepoliaEthConfig() public pure returns (NetworkConfig memory config) {
        // This is a mock address, replace it with the actual price feed address
        config = NetworkConfig({priceFeed: 0x694AA1769357215DE4FAC081bf1f309aDC325306});
    }

    function GetAnvilEthConfig() public  returns (NetworkConfig memory config) {
        if (activeNetworkConfig.priceFeed != address(0)) {
            return activeNetworkConfig; 
            
        }
        vm.startBroadcast();
        MockV3Aggregator mockV3Aggregator = new MockV3Aggregator(DECIMALS, INITIAL_PRICE); // 2000 USD
        vm.stopBroadcast();
        config = NetworkConfig({priceFeed: address(mockV3Aggregator)});
    }

    function run() external returns (address priceFeed) {
        // This is a mock address, replace it with the actual price feed address
        priceFeed = 0x694AA1769357215DE4FAC081bf1f309aDC325306;
        vm.startBroadcast();
        // Deploy any necessary contracts or configurations here
        vm.stopBroadcast();
    }
}
