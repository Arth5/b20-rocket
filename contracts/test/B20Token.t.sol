// SPDX-License-Identifier: MIT
pragma solidity ^0.8.28;

import {Test} from "forge-std/Test.sol";
import {B20Token} from "../src/B20Token.sol";

contract B20TokenTest is Test {
    B20Token internal token;

    address internal owner = address(0xA11CE);

    function setUp() public {
        token = new B20Token(
            "B20 Rocket",
            "B20",
            1_000_000,
            owner
        );
    }

    function testInitialTokenConfiguration() public view {
        assertEq(token.name(), "B20 Rocket");
        assertEq(token.symbol(), "B20");
        assertEq(token.decimals(), 18);
        assertEq(token.owner(), owner);
        assertEq(token.totalSupply(), 1_000_000 * 10 ** 18);
        assertEq(token.balanceOf(owner), 1_000_000 * 10 ** 18);
    }

    function testOwnerCanMintMoreTokens() public {
        uint256 supplyBefore = token.totalSupply();
        uint256 balanceBefore = token.balanceOf(owner);

        vm.prank(owner);
        token.mint(owner, 500);

        assertEq(
           token.totalSupply(),
           supplyBefore + (500 * 10 ** token.decimals())
        );

        assertEq(
           token.balanceOf(owner),
           balanceBefore + (500 * 10 ** token.decimals())
        );
    }
}