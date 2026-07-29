// SPDX-License-Identifier: MIT
pragma solidity ^0.8.28;

import {Test} from "forge-std/Test.sol";
import {B20Launchpad} from "../src/B20Launchpad.sol";
import {B20Token} from "../src/B20Token.sol";

contract B20LaunchpadTest is Test {
    B20Launchpad internal launchpad;

    address internal creator = address(0xA11CE);
    uint256 internal unit = 10 ** 18;

    function setUp() public {
        launchpad = new B20Launchpad();
    }

    function testCreateToken() public {
        vm.prank(creator);

        address tokenAddress = launchpad.createToken(
            "Rocket Test",
            "RTEST",
            1_000_000
        );

        B20Token token = B20Token(tokenAddress);

        assertTrue(tokenAddress != address(0));

        assertEq(
            token.name(),
            "Rocket Test"
        );

        assertEq(
            token.symbol(),
            "RTEST"
        );

        assertEq(
            token.owner(),
            creator
        );

        assertEq(
            token.totalSupply(),
            1_000_000 * unit
        );

        assertEq(
            token.balanceOf(creator),
            1_000_000 * unit
        );
    }

    function testTwoUsersCanCreateIndependentTokens() public {
        address creatorTwo = address(0xB0B);

        vm.prank(creator);

        address tokenOneAddress = launchpad.createToken(
            "Token One",
            "ONE",
            1_000
        );

        vm.prank(creatorTwo);

        address tokenTwoAddress = launchpad.createToken(
            "Token Two",
            "TWO",
            2_000
        );

        B20Token tokenOne = B20Token(tokenOneAddress);
        B20Token tokenTwo = B20Token(tokenTwoAddress);

        assertTrue(tokenOneAddress != tokenTwoAddress);

        assertEq(
            tokenOne.owner(),
            creator
        );

        assertEq(
            tokenTwo.owner(),
            creatorTwo
        );

        assertEq(
            tokenOne.balanceOf(creator),
            1_000 * unit
        );

        assertEq(
            tokenTwo.balanceOf(creatorTwo),
            2_000 * unit
        );

        assertEq(
            tokenOne.balanceOf(creatorTwo),
            0
        );

        assertEq(
            tokenTwo.balanceOf(creator),
            0
        );
    }
}