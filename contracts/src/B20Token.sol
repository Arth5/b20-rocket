// SPDX-License-Identifier: MIT
pragma solidity ^0.8.28;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract B20Token is ERC20, Ownable {
    constructor(
       string memory name_,
       string memory symbol_,
       address initialOwner_
    )
       ERC20(name_, symbol_)
       Ownable(initialOwner_)
    {}
}