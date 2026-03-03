// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import {Test} from "forge-std/Test.sol";
import {ERC721SoulboundTestable} from "../../../src/standards/ERC5192/ERC721SoulboundTestable.sol";
import {IERC5192} from "../../../src/shared/interfaces/IERC5192.sol";

contract ERC5192Test is Test {
    ERC721SoulboundTestable public token;

    address public owner = address(0x1);
    address public user1 = address(0x2);
    address public user2 = address(0x3);

    event Locked(uint256 indexed tokenId);
    event Unlocked(uint256 indexed tokenId);
    event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);

    function setUp() public {
        vm.prank(owner);
        token = new ERC721SoulboundTestable("Soulbound", "SBT");
    }

    function test_Locked_ReturnsFalseForUnlockedToken() public {
        token.mintUnlocked(user1, 1);
        assertFalse(token.locked(1), "Token should be unlocked");
    }

    function test_Locked_ReturnsTrueForLockedToken() public {
        token.mintLocked(user1, 1);
        assertTrue(token.locked(1), "Token should be locked");
    }

    function test_Transfer_RevertsWhenLocked() public {
        token.mintLocked(user1, 1);

        vm.prank(user1);
        vm.expectRevert("ERC5192: token is soulbound and cannot be transferred");
        token.transferFrom(user1, user2, 1);
    }

    function test_Transfer_SucceedsWhenUnlocked() public {
        token.mintUnlocked(user1, 1);

        vm.prank(user1);
        token.transferFrom(user1, user2, 1);

        assertEq(token.ownerOf(1), user2);
    }

    function test_Lock_EmitsLockedEvent() public {
        token.mintUnlocked(user1, 1);

        vm.prank(user1);
        vm.expectEmit(true, true, true, true);
        emit Locked(1);
        token.lock(1);
    }

    function test_Unlock_EmitsUnlockedEvent() public {
        token.mintLocked(user1, 1);

        vm.prank(user1);
        vm.expectEmit(true, true, true, true);
        emit Unlocked(1);
        token.unlock(1);
    }

    function test_Unlock_AllowsTransfer() public {
        token.mintLocked(user1, 1);
        vm.prank(user1);
        token.unlock(1);

        vm.prank(user1);
        token.transferFrom(user1, user2, 1);
        assertEq(token.ownerOf(1), user2);
    }

    function test_SupportsInterface_IERC5192() public view {
        assertTrue(token.supportsInterface(type(IERC5192).interfaceId));
    }

    function test_Locked_RevertsForNonExistentToken() public {
        vm.expectRevert("ERC721: invalid token ID");
        token.locked(999);
    }
}
