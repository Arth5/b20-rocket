// SPDX-License-Identifier: MIT
pragma solidity ^0.8.28;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract B20Token is ERC20, Ownable {
    constructor()
        ERC20("B20 Rocket", "B20")
        Ownable(msg.sender)
    {

    }
}