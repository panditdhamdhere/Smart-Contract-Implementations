# ERC-4907 Rental NFT

## Overview

Implementation of the [ERC-4907 Rental NFT Standard](https://eips.ethereum.org/EIPS/eip-4907), adding a time-limited `user` role to ERC-721 NFTs. Separates ownership from usage rights for rentals.

## Features

- **User Role**: Permission to "use" the NFT without transfer rights
- **Expires**: UNIX timestamp automatically revokes user role
- **No Second Tx**: User role expires on-chain without owner action
- **EIP-165**: Interface detection (`0xad092b5c`)

## Contracts

- `ERC4907.sol`: Abstract extension with `setUser`, `userOf`, `userExpires`
- `ERC721Rental.sol`: ERC721 NFT with rental support
- `ERC721RentalTestable.sol`: Testable version with `mint`

## Usage

```solidity
import {ERC721Rental} from "./ERC721Rental.sol";

ERC721Rental nft = new ERC721Rental("Land", "LAND");
nft.mint(owner, 1);

// Owner rents to user for 7 days
uint64 expires = uint64(block.timestamp + 7 days);
nft.setUser(1, renter, expires);

// renter can "use" until expires; owner retains transfer rights
// After expires, userOf(1) returns address(0)
```

## Testing

```bash
forge test --match-path test/standards/ERC4907/ERC4907.t.sol
```
