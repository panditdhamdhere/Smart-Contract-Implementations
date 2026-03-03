// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import {Script, console} from "forge-std/Script.sol";
import {ERC721Rental} from "../src/standards/ERC4907/ERC721Rental.sol";

/**
 * @title ERC4907Deploy
 * @dev Deployment script for ERC721 Rental NFT
 */
contract ERC4907Deploy is Script {
    function run() external {
        uint256 deployerPrivateKey = vm.envUint("PRIVATE_KEY");

        string memory name = "Rental NFT";
        string memory symbol = "RNFT";

        vm.startBroadcast(deployerPrivateKey);

        ERC721Rental nft = new ERC721Rental(name, symbol);

        vm.stopBroadcast();

        console.log("ERC721 Rental deployed at:", address(nft));
    }
}
