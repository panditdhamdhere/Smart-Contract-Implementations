// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import {Test} from "forge-std/Test.sol";
import {ERC20Testable} from "../../../src/standards/ERC20/ERC20Testable.sol";

contract ERC20Test is Test {
    ERC20Testable public token;

    string constant NAME = "Test Token";
    string constant SYMBOL = "TST";
    uint8 constant DECIMALS = 18;
    uint256 constant INITIAL_SUPPLY = 1000000e18;

    address public owner = address(0x1);
    address public user1 = address(0x2);
    address public user2 = address(0x3);

    event Transfer(address indexed from, address indexed to, uint256 value);
    event Approval(address indexed owner, address indexed spender, uint256 value);

    function setUp() public {
        vm.prank(owner);
        token = new ERC20Testable(NAME, SYMBOL, DECIMALS, INITIAL_SUPPLY);
    }

    // ===== Constructor Tests =====

    function test_Constructor_SetsCorrectMetadata() public view {
        assertEq(token.name(), NAME, "Name should match");
        assertEq(token.symbol(), SYMBOL, "Symbol should match");
        assertEq(token.decimals(), DECIMALS, "Decimals should match");
    }

    function test_Constructor_MintsToDeployer() public view {
        assertEq(token.balanceOf(owner), INITIAL_SUPPLY, "Owner should receive initial supply");
        assertEq(token.totalSupply(), INITIAL_SUPPLY, "Total supply should match");
    }

    function test_Constructor_EmitsTransferEvent() public {
        vm.expectEmit(true, true, false, true);
        emit Transfer(address(0), owner, INITIAL_SUPPLY);

        vm.prank(owner);
        new ERC20Testable(NAME, SYMBOL, DECIMALS, INITIAL_SUPPLY);
    }

    // ===== Transfer Tests =====

    function test_Transfer_Success() public {
        vm.startPrank(owner);

        uint256 amount = 100e18;
        bool success = token.transfer(user1, amount);

        assertTrue(success, "Transfer should succeed");
        assertEq(token.balanceOf(owner), INITIAL_SUPPLY - amount, "Owner balance should decrease");
        assertEq(token.balanceOf(user1), amount, "User1 balance should increase");
    }

    function test_Transfer_EmitsTransferEvent() public {
        vm.startPrank(owner);

        uint256 amount = 100e18;
        vm.expectEmit(true, true, false, true);
        emit Transfer(owner, user1, amount);

        token.transfer(user1, amount);
    }

    function test_Transfer_RequiresPositiveBalance() public {
        // This test verifies that transfer requires the sender to have a balance
        vm.startPrank(user1);
        vm.expectRevert("ERC20: transfer amount exceeds balance");
        token.transfer(user2, 100e18);
        vm.stopPrank();
    }

    function test_Transfer_RevertsWhenToZeroAddress() public {
        vm.startPrank(owner);
        vm.expectRevert("ERC20: transfer to zero address");
        token.transfer(address(0), 100e18);
    }

    function test_Transfer_RevertsWhenInsufficientBalance() public {
        vm.startPrank(owner);
        vm.expectRevert("ERC20: transfer amount exceeds balance");
        token.transfer(user1, INITIAL_SUPPLY + 1);
    }

    function test_Transfer_SuccessWithZeroAmount() public {
        vm.startPrank(owner);

        bool success = token.transfer(user1, 0);

        assertTrue(success, "Zero amount transfer should succeed");
        assertEq(token.balanceOf(owner), INITIAL_SUPPLY, "Owner balance should not change");
    }

    // ===== Approve Tests =====

    function test_Approve_Success() public {
        vm.startPrank(owner);

        uint256 amount = 100e18;
        bool success = token.approve(user1, amount);

        assertTrue(success, "Approve should succeed");
        assertEq(token.allowance(owner, user1), amount, "Allowance should match");
    }

    function test_Approve_EmitsApprovalEvent() public {
        vm.startPrank(owner);

        uint256 amount = 100e18;
        vm.expectEmit(true, true, false, true);
        emit Approval(owner, user1, amount);

        token.approve(user1, amount);
    }

    function test_Approve_OnlyOwnerCanApprove() public {
        // This test verifies approval works from owner
        vm.startPrank(owner);
        bool success = token.approve(user1, 100e18);
        assertTrue(success, "Approve should succeed from owner");
    }

    function test_Approve_RevertsWhenSpenderZeroAddress() public {
        vm.startPrank(owner);
        vm.expectRevert("ERC20: approve to zero address");
        token.approve(address(0), 100e18);
    }

    function test_Approve_AllowsOverwrite() public {
        vm.startPrank(owner);

        uint256 amount1 = 100e18;
        uint256 amount2 = 200e18;

        token.approve(user1, amount1);
        assertEq(token.allowance(owner, user1), amount1, "First allowance should match");

        token.approve(user1, amount2);
        assertEq(token.allowance(owner, user1), amount2, "Second allowance should match");
    }

    // ===== TransferFrom Tests =====

    function test_TransferFrom_Success() public {
        vm.startPrank(owner);
        uint256 approval = 1000e18;
        token.approve(user1, approval);

        uint256 transferAmount = 300e18;
        vm.stopPrank();

        vm.prank(user1);
        bool success = token.transferFrom(owner, user2, transferAmount);

        assertTrue(success, "TransferFrom should succeed");
        assertEq(token.balanceOf(owner), INITIAL_SUPPLY - transferAmount, "Owner balance should decrease");
        assertEq(token.balanceOf(user2), transferAmount, "User2 balance should increase");
        assertEq(token.allowance(owner, user1), approval - transferAmount, "Allowance should decrease");
    }

    function test_TransferFrom_EmitsTransferEvent() public {
        vm.startPrank(owner);
        token.approve(user1, 1000e18);
        vm.stopPrank();

        vm.prank(user1);
        vm.expectEmit(true, true, false, true);
        emit Transfer(owner, user2, 300e18);

        token.transferFrom(owner, user2, 300e18);
    }

    function test_TransferFrom_RevertsWhenInsufficientAllowance() public {
        vm.startPrank(owner);
        token.approve(user1, 100e18);
        vm.stopPrank();

        vm.prank(user1);
        vm.expectRevert("ERC20: insufficient allowance");
        token.transferFrom(owner, user2, 200e18);
    }

    function test_TransferFrom_RevertsWhenInsufficientBalance() public {
        vm.startPrank(owner);
        token.approve(user1, type(uint256).max);
        vm.stopPrank();

        vm.prank(user1);
        vm.expectRevert("ERC20: transfer amount exceeds balance");
        token.transferFrom(owner, user2, INITIAL_SUPPLY + 1);
    }

    function test_TransferFrom_DoesNotReduceWhenMaxAllowance() public {
        vm.startPrank(owner);
        token.approve(user1, type(uint256).max);
        vm.stopPrank();

        vm.prank(user1);
        token.transferFrom(owner, user2, 100e18);

        assertEq(token.allowance(owner, user1), type(uint256).max, "Max allowance should not change");
    }

    function test_TransferFrom_SuccessWithFullAllowance() public {
        vm.startPrank(owner);
        uint256 approval = 500e18;
        token.approve(user1, approval);
        vm.stopPrank();

        vm.prank(user1);
        token.transferFrom(owner, user2, approval);

        assertEq(token.allowance(owner, user1), 0, "Allowance should be 0 after full transfer");
    }

    // ===== Mint Tests =====

    function test_Mint_Success() public {
        uint256 mintAmount = 1000e18;
        token.mint(user1, mintAmount);

        assertEq(token.balanceOf(user1), mintAmount, "User1 should receive minted tokens");
        assertEq(token.totalSupply(), INITIAL_SUPPLY + mintAmount, "Total supply should increase");
    }

    function test_Mint_EmitsTransferEvent() public {
        uint256 mintAmount = 1000e18;
        vm.expectEmit(true, true, false, true);
        emit Transfer(address(0), user1, mintAmount);

        token.mint(user1, mintAmount);
    }

    function test_Mint_RevertsWhenToZeroAddress() public {
        vm.expectRevert("ERC20: mint to zero address");
        token.mint(address(0), 100e18);
    }

    // ===== Burn Tests =====

    function test_Burn_Success() public {
        uint256 burnAmount = 100e18;
        token.burn(owner, burnAmount);

        assertEq(token.balanceOf(owner), INITIAL_SUPPLY - burnAmount, "Owner balance should decrease");
        assertEq(token.totalSupply(), INITIAL_SUPPLY - burnAmount, "Total supply should decrease");
    }

    function test_Burn_EmitsTransferEvent() public {
        uint256 burnAmount = 100e18;
        vm.expectEmit(true, true, false, true);
        emit Transfer(owner, address(0), burnAmount);

        token.burn(owner, burnAmount);
    }

    function test_Burn_RevertsWhenFromZeroAddress() public {
        vm.expectRevert("ERC20: burn from zero address");
        token.burn(address(0), 100e18);
    }

    function test_Burn_RevertsWhenAmountExceedsBalance() public {
        vm.expectRevert("ERC20: burn amount exceeds balance");
        token.burn(owner, INITIAL_SUPPLY + 1);
    }

    function test_Burn_SuccessWithFullBalance() public {
        token.burn(owner, INITIAL_SUPPLY);

        assertEq(token.balanceOf(owner), 0, "Owner balance should be 0");
        assertEq(token.totalSupply(), 0, "Total supply should be 0");
    }

    // ===== Edge Case Tests =====

    function test_MultipleTransfers_Success() public {
        vm.startPrank(owner);

        token.transfer(user1, 100e18);
        token.transfer(user2, 200e18);

        assertEq(token.balanceOf(owner), INITIAL_SUPPLY - 300e18, "Owner should have remaining balance");
        assertEq(token.balanceOf(user1), 100e18, "User1 should have 100 tokens");
        assertEq(token.balanceOf(user2), 200e18, "User2 should have 200 tokens");
    }

    function test_TransferFromThenTransfer_Success() public {
        vm.startPrank(owner);
        token.approve(user1, 1000e18);
        vm.stopPrank();

        vm.prank(user1);
        token.transferFrom(owner, user2, 300e18);

        vm.prank(owner);
        token.transfer(user1, 500e18);

        assertEq(token.balanceOf(user2), 300e18, "User2 should have 300 tokens");
        assertEq(token.balanceOf(user1), 500e18, "User1 should have 500 tokens");
    }

    function test_VeryLargeAmount_Success() public {
        vm.startPrank(owner);

        token.approve(user1, type(uint256).max);
        vm.stopPrank();

        vm.prank(user1);
        token.transferFrom(owner, user2, INITIAL_SUPPLY);

        assertEq(token.balanceOf(user2), INITIAL_SUPPLY, "User2 should have all tokens");
    }

    // ===== State Query Tests =====

    function test_TotalSupply_ReturnsCorrectly() public view {
        assertEq(token.totalSupply(), INITIAL_SUPPLY, "Total supply should be correct");
    }

    function test_BalanceOf_ReturnsCorrectly() public view {
        assertEq(token.balanceOf(owner), INITIAL_SUPPLY, "Owner balance should be correct");
        assertEq(token.balanceOf(user1), 0, "User1 balance should be 0");
    }

    function test_Allowance_DefaultsToZero() public view {
        assertEq(token.allowance(owner, user1), 0, "Default allowance should be 0");
    }
}
