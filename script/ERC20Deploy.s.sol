// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import {Script, console} from "forge-std/Script.sol";
import {ERC20} from "../src/standards/ERC20/ERC20.sol";

/**
 * @title ERC20Deploy
 * @dev Deployment script for ERC20 token
 */
contract ERC20Deploy is Script {
    function run() external {
        uint256 deployerPrivateKey = vm.envUint("PRIVATE_KEY");

        // Token parameters - modify these as needed
        string memory name = "My Token";
        string memory symbol = "MT";
        uint8 decimals = 18;
        uint256 totalSupply = 1000000e18; // 1 million tokens

        vm.startBroadcast(deployerPrivateKey);

        ERC20 token = new ERC20(name, symbol, decimals, totalSupply);

        vm.stopBroadcast();

        console.log("Token deployed at:", address(token));
        console.log("Token name:", name);
        console.log("Token symbol:", symbol);
        console.log("Total supply:", totalSupply);
    }
}
