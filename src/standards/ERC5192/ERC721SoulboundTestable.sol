// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import {ERC5192} from "./ERC5192.sol";

/**
 * @title ERC721SoulboundTestable
 * @dev Testable Soulbound NFT - supports both locked and unlocked minting
 * @notice DO NOT use in production - use ERC721Soulbound instead
 */
contract ERC721SoulboundTestable is ERC5192 {
    constructor(string memory name_, string memory symbol_) ERC5192(name_, symbol_) {}

    function mint(address to, uint256 tokenId) external {
        _mint(to, tokenId);
    }

    function mintLocked(address to, uint256 tokenId) external {
        _mint(to, tokenId);
        _lock(tokenId);
    }

    function mintUnlocked(address to, uint256 tokenId) external {
        _mint(to, tokenId);
        // Token remains unlocked
    }

    function lock(uint256 tokenId) external {
        require(ownerOf(tokenId) == msg.sender, "ERC5192: caller is not owner");
        _lock(tokenId);
    }

    function unlock(uint256 tokenId) external {
        require(ownerOf(tokenId) == msg.sender, "ERC5192: caller is not owner");
        _unlock(tokenId);
    }
}
