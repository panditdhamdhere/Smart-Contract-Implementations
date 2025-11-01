# ERC20 Implementation

A comprehensive, modular implementation of the ERC-20 Token Standard following EIP-20.

## 📋 Overview

This implementation provides a fully compliant ERC-20 token with all standard features:

- **Standard Functions**: `transfer`, `transferFrom`, `approve`, `balanceOf`, `allowance`, `totalSupply`
- **Metadata**: `name`, `symbol`, `decimals` as per EIP-20 extension
- **Internal Functions**: `_mint`, `_burn` for token lifecycle management
- **Events**: `Transfer` and `Approval` events as per standard
- **Gas Optimized**: Uses `unchecked` blocks where safe for gas efficiency

## 📁 Files

- **ERC20.sol**: Main production ERC20 implementation
- **ERC20Testable.sol**: Testable version exposing internal mint/burn functions
- **Test**: Comprehensive test suite with 34 test cases

## 🚀 Usage

### Deployment

Deploy using the included script:

```bash
forge script script/ERC20Deploy.s.sol:ERC20Deploy --rpc-url <RPC_URL> --private-key <KEY> --broadcast
```

Or deploy directly:

```solidity
import {ERC20} from "src/standards/ERC20/ERC20.sol";

ERC20 token = new ERC20(
    "My Token",      // name
    "MT",            // symbol
    18,              // decimals
    1000000e18       // initial supply
);
```

### Basic Operations

```solidity
// Transfer tokens
token.transfer(recipient, amount);

// Approve spending
token.approve(spender, amount);

// Transfer from approved allowance
token.transferFrom(from, to, amount);

// Check balance
uint256 balance = token.balanceOf(address);

// Check allowance
uint256 allowed = token.allowance(owner, spender);
```

## ✅ Test Coverage

The implementation includes comprehensive test coverage with 34 test cases:

### Constructor Tests
- ✅ Sets correct metadata (name, symbol, decimals)
- ✅ Mints initial supply to deployer
- ✅ Emits Transfer event on deployment

### Transfer Tests
- ✅ Successful transfer
- ✅ Emits Transfer event
- ✅ Reverts when balance insufficient
- ✅ Reverts when sending to zero address
- ✅ Supports zero amount transfers

### Approve Tests
- ✅ Successful approval
- ✅ Emits Approval event
- ✅ Reverts when spender is zero address
- ✅ Allows overwriting approvals

### TransferFrom Tests
- ✅ Successful transfer with allowance
- ✅ Emits Transfer event
- ✅ Reverts when allowance insufficient
- ✅ Reverts when balance insufficient
- ✅ Doesn't reduce allowance when max(uint256) set
- ✅ Reduces allowance correctly on use

### Mint/Burn Tests
- ✅ Mint increases supply and balance
- ✅ Burn decreases supply and balance
- ✅ Emits Transfer events
- ✅ Reverts on invalid addresses
- ✅ Reverts when amount exceeds balance

### Edge Cases
- ✅ Multiple transfers
- ✅ Complex approval/transfer scenarios
- ✅ Very large amounts
- ✅ Zero amounts

## 🔒 Security Features

- ✅ Input validation on all functions
- ✅ Zero address checks
- ✅ Balance/allowance checks before operations
- ✅ Safe arithmetic with `unchecked` blocks where appropriate
- ✅ No known vulnerabilities

## 📊 Gas Optimization

The implementation uses several gas optimization techniques:

- **Unchecked arithmetic**: Used for decrements where underflow is impossible
- **Pack storage variables**: Efficient storage layout
- **Minimal storage reads**: Cache values when used multiple times
- **Early returns**: Return values efficiently

### Gas Costs (Approximate)

| Function      | Min Gas | Avg Gas | Max Gas |
|---------------|---------|---------|---------|
| transfer      | 22,494  | 40,030  | 51,843  |
| transferFrom  | 25,151  | 48,900  | 59,753  |
| approve       | 22,429  | 43,729  | 46,914  |
| balanceOf     | 2,851   | 2,851   | 2,851   |
| allowance     | 3,245   | 3,245   | 3,245   |
| mint          | 22,358  | 41,778  | 51,489  |
| burn          | 22,424  | 28,681  | 34,390  |

## 🧪 Running Tests

```bash
# Run all ERC20 tests
forge test --match-path test/standards/ERC20/ERC20.t.sol

# Run with verbosity
forge test --match-path test/standards/ERC20/ERC20.t.sol -vv

# Run with gas report
forge test --match-path test/standards/ERC20/ERC20.t.sol --gas-report
```

## 📚 Resources

- [EIP-20 Specification](https://eips.ethereum.org/EIPS/eip-20)
- [Foundry Documentation](https://book.getfoundry.sh/)

## ⚠️ Disclaimer

**DO NOT deploy to mainnet without a comprehensive security audit.** This code is provided for educational and reference purposes only.

