// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import {Test} from "forge-std/Test.sol";
import {ERC721RentalTestable} from "../../../src/standards/ERC4907/ERC721RentalTestable.sol";
import {IERC4907} from "../../../src/shared/interfaces/IERC4907.sol";

contract ERC4907Test is Test {
    ERC721RentalTestable public token;

    address public owner = address(0x1);
    address public user1 = address(0x2);
    address public user2 = address(0x3);

    event UpdateUser(uint256 indexed tokenId, address indexed user, uint64 expires);

    function setUp() public {
        vm.prank(owner);
        token = new ERC721RentalTestable("Rental NFT", "RNFT");
    }

    function test_SetUser_Success() public {
        token.mint(owner, 1);
        uint64 expires = uint64(block.timestamp + 1 days);

        vm.prank(owner);
        token.setUser(1, user1, expires);

        assertEq(token.userOf(1), user1);
        assertEq(token.userExpires(1), expires);
    }

    function test_SetUser_EmitsUpdateUserEvent() public {
        token.mint(owner, 1);
        uint64 expires = uint64(block.timestamp + 1 days);

        vm.prank(owner);
        vm.expectEmit(true, true, true, true);
        emit UpdateUser(1, user1, expires);
        token.setUser(1, user1, expires);
    }

    function test_UserOf_ReturnsZeroWhenExpired() public {
        token.mint(owner, 1);
        uint64 expires = uint64(block.timestamp + 1 hours);
        vm.prank(owner);
        token.setUser(1, user1, expires);

        vm.warp(block.timestamp + 2 hours);
        assertEq(token.userOf(1), address(0));
    }

    function test_UserOf_ReturnsUserWhenNotExpired() public {
        token.mint(owner, 1);
        uint64 expires = uint64(block.timestamp + 1 days);
        vm.prank(owner);
        token.setUser(1, user1, expires);

        assertEq(token.userOf(1), user1);
    }

    function test_SetUser_RevertsWhenNotOwnerOrApproved() public {
        token.mint(owner, 1);
        uint64 expires = uint64(block.timestamp + 1 days);

        vm.prank(user2);
        vm.expectRevert("ERC4907: caller is not owner nor approved");
        token.setUser(1, user1, expires);
    }

    function test_Transfer_ClearsUser() public {
        token.mint(owner, 1);
        vm.prank(owner);
        token.setUser(1, user1, uint64(block.timestamp + 1 days));

        vm.prank(owner);
        token.transferFrom(owner, user2, 1);

        assertEq(token.ownerOf(1), user2);
        assertEq(token.userOf(1), address(0));
        assertEq(token.userExpires(1), 0);
    }

    function test_SupportsInterface_IERC4907() public view {
        assertTrue(token.supportsInterface(type(IERC4907).interfaceId));
    }
}
