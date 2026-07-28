// SPDX-License-Identifier: MIT
pragma solidity ^0.8.28;

import {Test} from "forge-std/Test.sol";
import {B20Token} from "../src/B20Token.sol";

contract B20TokenTest is Test {
    B20Token internal token;

    address internal owner = address(0xA11CE);
    address internal holder = address(0xB0B);

    uint256 internal unit = 10 ** 18;

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

        assertEq(
            token.totalSupply(),
            1_000_000 * unit
        );

        assertEq(
            token.balanceOf(owner),
            1_000_000 * unit
        );
    }

    function testOwnerCanTransferTokens() public {
        vm.prank(owner);

        token.transfer(
            holder,
            1_000 * unit
        );

        assertEq(
            token.balanceOf(holder),
            1_000 * unit
        );

        assertEq(
            token.balanceOf(owner),
            999_000 * unit
        );
    }

    function testHolderCanBurnOwnTokens() public {
        vm.prank(owner);

        token.transfer(
            holder,
            1_000 * unit
        );

        uint256 supplyBefore = token.totalSupply();

        vm.prank(holder);

        token.burn(400);

        assertEq(
            token.balanceOf(holder),
            600 * unit
        );

        assertEq(
            token.totalSupply(),
            supplyBefore - (400 * unit)
        );
    }

    function testHolderCannotBurnMoreThanOwnBalance() public {
        vm.prank(owner);

        token.transfer(
            holder,
            100 * unit
        );

        vm.prank(holder);

        vm.expectRevert();

        token.burn(101);
    }

    function testOwnerBurnDoesNotAffectAnotherWallet() public {
        vm.prank(owner);

        token.transfer(
            holder,
            1_000 * unit
        );

        uint256 holderBalanceBefore =
            token.balanceOf(holder);

        vm.prank(owner);

        token.burn(1_000);

        assertEq(
            token.balanceOf(holder),
            holderBalanceBefore
        );
    }

    function testBurnReducesTotalSupply() public {
        uint256 supplyBefore =
            token.totalSupply();

        vm.prank(owner);

        token.burn(500);

        assertEq(
            token.totalSupply(),
            supplyBefore - (500 * unit)
        );
    }

    function testGetOwnerReturnsCorrectOwner() public view {
        assertEq(
            token.getOwner(),
            owner
        );
    }

    function testExistsReturnsCorrectStatus() public {
        assertTrue(
            token.exists(owner)
        );

        assertFalse(
            token.exists(holder)
        );

        vm.prank(owner);

        token.transfer(
            holder,
            100 * unit
        );

        assertTrue(
            token.exists(holder)
        );
    }

    function testGetBalanceReturnsCorrectBalance() public view {
        assertEq(
            token.getBalance(owner),
            1_000_000 * unit
        );
    }

    function testGetTokenInfoReturnsCorrectData() public view {
        (
            string memory tokenName,
            string memory tokenSymbol,
            uint8 tokenDecimals,
            uint256 supply
        ) = token.getTokenInfo();

        assertEq(
            tokenName,
            "B20 Rocket"
        );

        assertEq(
            tokenSymbol,
            "B20"
        );

        assertEq(
            tokenDecimals,
            18
        );

        assertEq(
            supply,
            1_000_000 * unit
        );
    }
}