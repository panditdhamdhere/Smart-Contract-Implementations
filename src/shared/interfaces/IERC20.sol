// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/**
 * @title IERC20
 * @dev Standard ERC20 Token interface
 * @notice See https://eips.ethereum.org/EIPS/eip-20 for full specification
 */
interface IERC20 {
    /**
     * @dev Emitted when `value` tokens are moved from one account (`from`) to another (`to`)
     */
    event Transfer(address indexed from, address indexed to, uint256 value);

    /**
     * @dev Emitted when the allowance of a `spender` for an `owner` is set by a call to `approve`.
     * `value` is the new allowance.
     */
    event Approval(address indexed owner, address indexed spender, uint256 value);

    /**
     * @dev Returns the total supply of tokens
     */
    function totalSupply() external view returns (uint256);

    /**
     * @dev Returns the amount of tokens owned by `account`
     * @param account The address to query
     */
    function balanceOf(address account) external view returns (uint256);

    /**
     * @dev Moves `amount` tokens from the caller's account to `to`
     * @param to The recipient address
     * @param amount The amount to transfer
     * @return success Boolean indicating if the transfer was successful
     */
    function transfer(address to, uint256 amount) external returns (bool);

    /**
     * @dev Returns the remaining number of tokens that `spender` will be allowed to spend on behalf of `owner`
     * @param owner The owner address
     * @param spender The spender address
     */
    function allowance(address owner, address spender) external view returns (uint256);

    /**
     * @dev Sets `amount` as the allowance of `spender` over the caller's tokens
     * @param spender The spender address
     * @param amount The amount of allowance
     * @return success Boolean indicating if the approval was successful
     */
    function approve(address spender, uint256 amount) external returns (bool);

    /**
     * @dev Moves `amount` tokens from `from` to `to` using the allowance mechanism
     * @param from The sender address
     * @param to The recipient address
     * @param amount The amount to transfer
     * @return success Boolean indicating if the transfer was successful
     */
    function transferFrom(address from, address to, uint256 amount) external returns (bool);
}
