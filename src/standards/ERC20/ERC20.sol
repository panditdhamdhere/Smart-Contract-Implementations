// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import {IERC20} from "../../shared/interfaces/IERC20.sol";
import {IERC20Metadata} from "../../shared/interfaces/IERC20Metadata.sol";

/**
 * @title ERC20
 * @dev Implementation of the ERC20 Token standard
 * @notice This is a fully compliant ERC20 token implementation following EIP-20
 * @custom:security-contact This contract should be audited before use in production
 */
contract ERC20 is IERC20, IERC20Metadata {
    // Token metadata
    string private _name;
    string private _symbol;
    uint8 private _decimals;

    // Balances mapping: address => balance
    mapping(address => uint256) private _balances;

    // Allowances mapping: owner => spender => amount
    mapping(address => mapping(address => uint256)) private _allowances;

    // Total supply of tokens
    uint256 private _totalSupply;

    /**
     * @dev Creates an ERC20 token with the given parameters
     * @param name_ Token name
     * @param symbol_ Token symbol
     * @param decimals_ Token decimals (typically 18)
     * @param totalSupply_ Initial total supply to mint to deployer
     */
    constructor(string memory name_, string memory symbol_, uint8 decimals_, uint256 totalSupply_) {
        _name = name_;
        _symbol = symbol_;
        _decimals = decimals_;
        _totalSupply = totalSupply_;
        _balances[msg.sender] = totalSupply_;
        emit Transfer(address(0), msg.sender, totalSupply_);
    }

    /**
     * @dev Returns the name of the token
     */
    function name() public view virtual override returns (string memory) {
        return _name;
    }

    /**
     * @dev Returns the symbol of the token
     */
    function symbol() public view virtual override returns (string memory) {
        return _symbol;
    }

    /**
     * @dev Returns the decimals of the token
     */
    function decimals() public view virtual override returns (uint8) {
        return _decimals;
    }

    /**
     * @dev Returns the total supply of tokens
     */
    function totalSupply() public view virtual override returns (uint256) {
        return _totalSupply;
    }

    /**
     * @dev Returns the balance of the specified address
     * @param account The address to query
     */
    function balanceOf(address account) public view virtual override returns (uint256) {
        return _balances[account];
    }

    /**
     * @dev Moves `amount` tokens from caller's account to `to`
     * @param to The recipient address
     * @param amount The amount to transfer
     * @return success Boolean indicating success
     */
    function transfer(address to, uint256 amount) public virtual override returns (bool) {
        address owner = msg.sender;
        _transfer(owner, to, amount);
        return true;
    }

    /**
     * @dev Returns the remaining allowance of `spender` for `owner`
     * @param owner The owner address
     * @param spender The spender address
     */
    function allowance(address owner, address spender) public view virtual override returns (uint256) {
        return _allowances[owner][spender];
    }

    /**
     * @dev Sets `amount` as allowance of `spender` over caller's tokens
     * @param spender The spender address
     * @param amount The amount of allowance
     * @return success Boolean indicating success
     */
    function approve(address spender, uint256 amount) public virtual override returns (bool) {
        address owner = msg.sender;
        _approve(owner, spender, amount);
        return true;
    }

    /**
     * @dev Moves `amount` tokens from `from` to `to` using allowance mechanism
     * @param from The sender address
     * @param to The recipient address
     * @param amount The amount to transfer
     * @return success Boolean indicating success
     */
    function transferFrom(address from, address to, uint256 amount) public virtual override returns (bool) {
        address spender = msg.sender;
        _spendAllowance(from, spender, amount);
        _transfer(from, to, amount);
        return true;
    }

    /**
     * @dev Internal function to move tokens from `from` to `to`
     * @param from The sender address
     * @param to The recipient address
     * @param amount The amount to transfer
     */
    function _transfer(address from, address to, uint256 amount) internal virtual {
        require(from != address(0), "ERC20: transfer from zero address");
        require(to != address(0), "ERC20: transfer to zero address");

        uint256 fromBalance = _balances[from];
        require(fromBalance >= amount, "ERC20: transfer amount exceeds balance");

        unchecked {
            _balances[from] = fromBalance - amount;
            _balances[to] += amount;
        }

        emit Transfer(from, to, amount);
    }

    /**
     * @dev Internal function to mint tokens to `to`
     * @param to The recipient address
     * @param amount The amount to mint
     */
    function _mint(address to, uint256 amount) internal virtual {
        require(to != address(0), "ERC20: mint to zero address");

        _totalSupply += amount;
        unchecked {
            _balances[to] += amount;
        }
        emit Transfer(address(0), to, amount);
    }

    /**
     * @dev Internal function to burn tokens from `from`
     * @param from The address to burn from
     * @param amount The amount to burn
     */
    function _burn(address from, uint256 amount) internal virtual {
        require(from != address(0), "ERC20: burn from zero address");

        uint256 accountBalance = _balances[from];
        require(accountBalance >= amount, "ERC20: burn amount exceeds balance");

        unchecked {
            _balances[from] = accountBalance - amount;
            _totalSupply -= amount;
        }

        emit Transfer(from, address(0), amount);
    }

    /**
     * @dev Internal function to set allowance of `spender` for `owner`
     * @param owner The owner address
     * @param spender The spender address
     * @param amount The amount of allowance
     */
    function _approve(address owner, address spender, uint256 amount) internal virtual {
        require(owner != address(0), "ERC20: approve from zero address");
        require(spender != address(0), "ERC20: approve to zero address");

        _allowances[owner][spender] = amount;
        emit Approval(owner, spender, amount);
    }

    /**
     * @dev Internal function to spend allowance
     * @param owner The owner address
     * @param spender The spender address
     * @param amount The amount to spend
     */
    function _spendAllowance(address owner, address spender, uint256 amount) internal virtual {
        uint256 currentAllowance = allowance(owner, spender);
        if (currentAllowance != type(uint256).max) {
            require(currentAllowance >= amount, "ERC20: insufficient allowance");
            unchecked {
                _approve(owner, spender, currentAllowance - amount);
            }
        }
    }
}
