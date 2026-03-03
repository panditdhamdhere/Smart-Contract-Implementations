// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import {ERC5192} from "./ERC5192.sol";

/**
 * @title ERC721Soulbound
 * @dev ERC721 NFT where all tokens are soulbound (locked on mint)
 */
contract ERC721Soulbound is ERC5192 {
    constructor(string memory name_, string memory symbol_) ERC5192(name_, symbol_) {}

    /**
     * @dev Mints a soulbound token. Token is locked and cannot be transferred.
     * Override to add access control (e.g. onlyOwner) in production.
     */
    function mint(address to, uint256 tokenId) public virtual {
        _mint(to, tokenId);
    }

    /**
     * @dev Mints and locks token. Called by public mint().
     */
    function _mint(address to, uint256 tokenId) internal virtual override {
        super._mint(to, tokenId);
        _lock(tokenId);
    }
}
