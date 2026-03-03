# ERC-5192 Minimal Soulbound NFTs

## Overview

Implementation of the [ERC-5192 Minimal Soulbound NFT Standard](https://eips.ethereum.org/EIPS/eip-5192). Soulbound tokens (SBTs) are non-transferable NFTs bound to a single account.

## Features

- **Locked/Unlocked**: Tokens can be locked (soulbound) or unlocked
- **Transfer Restriction**: When locked, all ERC-721 transfer functions revert
- **EIP-165**: Interface detection (`0xb45a3c0e`) for wallet compatibility

## Contracts

- `ERC5192.sol`: Abstract extension overriding `_transfer` to enforce locking
- `ERC721Soulbound.sol`: ERC721 NFT with all tokens locked on mint
- `ERC721SoulboundTestable.sol`: Testable version with `mintLocked`/`mintUnlocked`/`lock`/`unlock`

## Usage

### Soulbound Collection (all tokens locked)

```solidity
import {ERC721Soulbound} from "./ERC721Soulbound.sol";

ERC721Soulbound sbt = new ERC721Soulbound("Achievement", "ACHV");
sbt.mint(recipient, tokenId);  // Token is locked and cannot be transferred
```

### Custom Locking Logic

```solidity
import {ERC5192} from "./ERC5192.sol";

contract MySBT is ERC5192 {
    function mint(address to, uint256 tokenId) external {
        _mint(to, tokenId);
        _lock(tokenId);  // Optional: lock after mint
    }
}
```

## Testing

```bash
forge test --match-path test/standards/ERC5192/ERC5192.t.sol
```
