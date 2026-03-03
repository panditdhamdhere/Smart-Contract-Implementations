// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import {ERC4907} from "./ERC4907.sol";

/**
 * @title ERC721RentalTestable
 * @dev Testable Rental NFT with mint function
 * @notice DO NOT use in production - use ERC721Rental instead
 */
contract ERC721RentalTestable is ERC4907 {
    constructor(string memory name_, string memory symbol_) ERC4907(name_, symbol_) {}

    function mint(address to, uint256 tokenId) external {
        _mint(to, tokenId);
    }
}
