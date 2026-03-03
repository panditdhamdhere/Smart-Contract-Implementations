// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import {Script, console} from "forge-std/Script.sol";
import {ERC721Soulbound} from "../src/standards/ERC5192/ERC721Soulbound.sol";

/**
 * @title ERC5192Deploy
 * @dev Deployment script for ERC721 Soulbound NFT
 */
contract ERC5192Deploy is Script {
    function run() external {
        uint256 deployerPrivateKey = vm.envUint("PRIVATE_KEY");

        string memory name = "Soulbound NFT";
        string memory symbol = "SBT";

        vm.startBroadcast(deployerPrivateKey);

        ERC721Soulbound sbt = new ERC721Soulbound(name, symbol);

        vm.stopBroadcast();

        console.log("ERC721 Soulbound deployed at:", address(sbt));
    }
}
