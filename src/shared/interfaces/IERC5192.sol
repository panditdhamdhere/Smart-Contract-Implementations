// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/**
 * @title IERC5192
 * @dev Minimal Soulbound NFT interface (EIP-5192)
 * @notice See https://eips.ethereum.org/EIPS/eip-5192
 */
interface IERC5192 {
    /// @notice Emitted when the locking status is changed to locked.
    /// @param tokenId The identifier for a token.
    event Locked(uint256 indexed tokenId);

    /// @notice Emitted when the locking status is changed to unlocked.
    /// @param tokenId The identifier for a token.
    event Unlocked(uint256 indexed tokenId);

    /// @notice Returns the locking status of a Soulbound Token
    /// @dev SBTs assigned to zero address are considered invalid, and queries about them do throw.
    /// @param tokenId The identifier for an SBT.
    /// @return True if the token is locked (soulbound), false otherwise
    function locked(uint256 tokenId) external view returns (bool);
}
