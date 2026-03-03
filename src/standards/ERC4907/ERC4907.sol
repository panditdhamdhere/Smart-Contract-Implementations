// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import {ERC721} from "../ERC721/ERC721.sol";
import {IERC4907} from "../../shared/interfaces/IERC4907.sol";
import {IERC165} from "../../shared/interfaces/IERC165.sol";
import {IERC721} from "../../shared/interfaces/IERC721.sol";
import {IERC721Metadata} from "../../shared/interfaces/IERC721Metadata.sol";

/**
 * @title ERC4907
 * @dev Rental NFT extension (EIP-4907) - adds user role and expires to ERC-721
 * @notice The user can "use" the NFT until expires; owner retains transfer rights
 */
abstract contract ERC4907 is ERC721, IERC4907 {
    constructor(string memory name_, string memory symbol_) ERC721(name_, symbol_) {}

    struct UserInfo {
        address user;
        uint64 expires;
    }

    mapping(uint256 => UserInfo) private _users;

    /**
     * @dev See {IERC4907-setUser}.
     */
    function setUser(uint256 tokenId, address user, uint64 expires) public virtual override {
        require(_isAuthorized(msg.sender, tokenId), "ERC4907: caller is not owner nor approved");
        _users[tokenId] = UserInfo({user: user, expires: expires});
        emit UpdateUser(tokenId, user, expires);
    }

    /**
     * @dev See {IERC4907-userOf}.
     */
    function userOf(uint256 tokenId) public view virtual override returns (address) {
        if (uint256(_users[tokenId].expires) >= block.timestamp) {
            return _users[tokenId].user;
        }
        return address(0);
    }

    /**
     * @dev See {IERC4907-userExpires}.
     */
    function userExpires(uint256 tokenId) public view virtual override returns (uint256) {
        return _users[tokenId].expires;
    }

    /**
     * @dev Clear user info when token is transferred
     */
    function _transfer(address from, address to, uint256 tokenId) internal virtual override {
        if (from != to && _users[tokenId].user != address(0)) {
            delete _users[tokenId];
            emit UpdateUser(tokenId, address(0), 0);
        }
        super._transfer(from, to, tokenId);
    }

    /**
     * @dev See {IERC165-supportsInterface}.
     */
    function supportsInterface(bytes4 interfaceId) public view virtual returns (bool) {
        return interfaceId == type(IERC4907).interfaceId || interfaceId == type(IERC721).interfaceId
            || interfaceId == type(IERC721Metadata).interfaceId || interfaceId == type(IERC165).interfaceId;
    }
}
