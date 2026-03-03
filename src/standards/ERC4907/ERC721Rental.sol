// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import {ERC4907} from "./ERC4907.sol";

/**
 * @title ERC721Rental
 * @dev ERC721 NFT with rental (user/expires) support
 */
contract ERC721Rental is ERC4907 {
    constructor(string memory name_, string memory symbol_) ERC4907(name_, symbol_) {}

    /**
     * @dev Mints a new token. Override to add access control in production.
     */
    function mint(address to, uint256 tokenId) public virtual {
        _mint(to, tokenId);
    }
}
