// SPDX-License-Identifier: MIT
pragma solidity ^0.8.28;

import {B20Token} from "./B20Token.sol";

contract B20Launchpad {
    event TokenCreated(
        address indexed creator,
        address indexed token,
        string name,
        string symbol,
        uint256 supply
    );

    function createToken(
        string memory name_,
        string memory symbol_,
        uint256 supply_
    ) external returns (address tokenAddress) {
        B20Token token = new B20Token(
            name_,
            symbol_,
            supply_,
            msg.sender
        );

        tokenAddress = address(token);

        emit TokenCreated(
            msg.sender,
            tokenAddress,
            name_,
            symbol_,
            supply_
        );
    }
}