// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import {ERC721} from "../ERC721/ERC721.sol";
import {IERC5192} from "../../shared/interfaces/IERC5192.sol";
import {IERC165} from "../../shared/interfaces/IERC165.sol";
import {IERC721} from "../../shared/interfaces/IERC721.sol";
import {IERC721Metadata} from "../../shared/interfaces/IERC721Metadata.sol";

/**
 * @title ERC5192
 * @dev Minimal Soulbound NFT extension (EIP-5192)
 * @notice When locked, tokens cannot be transferred. Extends ERC-721.
 */
abstract contract ERC5192 is ERC721, IERC5192 {
    constructor(string memory name_, string memory symbol_) ERC721(name_, symbol_) {}

    mapping(uint256 => bool) private _locked;

    /**
     * @dev Reverts if token is locked (soulbound). Override _transfer to prevent transfers.
     */
    function _transfer(address from, address to, uint256 tokenId) internal virtual override {
        require(!locked(tokenId), "ERC5192: token is soulbound and cannot be transferred");
        super._transfer(from, to, tokenId);
    }

    /**
     * @dev See {IERC5192-locked}.
     */
    function locked(uint256 tokenId) public view virtual override returns (bool) {
        _requireOwned(tokenId); // Reverts if token doesn't exist
        return _locked[tokenId];
    }

    /**
     * @dev Locks a token, making it soulbound. Emits Locked event.
     */
    function _lock(uint256 tokenId) internal virtual {
        _requireOwned(tokenId);
        require(!_locked[tokenId], "ERC5192: token already locked");
        _locked[tokenId] = true;
        emit Locked(tokenId);
    }

    /**
     * @dev Unlocks a token. Emits Unlocked event.
     */
    function _unlock(uint256 tokenId) internal virtual {
        _requireOwned(tokenId);
        require(_locked[tokenId], "ERC5192: token not locked");
        _locked[tokenId] = false;
        emit Unlocked(tokenId);
    }

    /**
     * @dev See {IERC165-supportsInterface}.
     */
    function supportsInterface(bytes4 interfaceId) public view virtual returns (bool) {
        return interfaceId == type(IERC5192).interfaceId || interfaceId == type(IERC721).interfaceId
            || interfaceId == type(IERC721Metadata).interfaceId || interfaceId == type(IERC165).interfaceId;
    }
}
