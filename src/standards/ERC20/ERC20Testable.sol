// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import {ERC20} from "./ERC20.sol";

/**
 * @title ERC20Testable
 * @dev Testable version of ERC20 that exposes internal functions for testing
 * @notice DO NOT use this in production - use ERC20 instead
 */
contract ERC20Testable is ERC20 {
    constructor(string memory name_, string memory symbol_, uint8 decimals_, uint256 totalSupply_)
        ERC20(name_, symbol_, decimals_, totalSupply_)
    {}

    /**
     * @dev Exposes _mint for testing purposes
     */
    function mint(address to, uint256 amount) external {
        _mint(to, amount);
    }

    /**
     * @dev Exposes _burn for testing purposes
     */
    function burn(address from, uint256 amount) external {
        _burn(from, amount);
    }
}
