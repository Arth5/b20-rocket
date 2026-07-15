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

    function testNonOwnerCannotMint() public {
        address attacker = address(0xBEEF);

        vm.prank(attacker);

        vm.expectRevert();

        token.mint(attacker, 100);
    }

    function testHolderCanBurnOwnTokens() public {
        uint256 supplyBefore = token.totalSupply();
        uint256 balanceBefore = token.balanceOf(owner);

        vm.prank(owner);
        token.burn(250);

        assertEq(
           token.totalSupply(),
           supplyBefore - (250 * 10 ** token.decimals())
        );

        assertEq(
           token.balanceOf(owner),
           balanceBefore - (250 * 10 ** token.decimals())
        );
    }

    function testOwnerCanBurnTokensFromAnotherAccount() public {
        address holder = address(0xCAFE);

        vm.prank(owner);
        token.mint(holder, 1_000);

        uint256 supplyBefore = token.totalSupply();
        uint256 balanceBefore = token.balanceOf(holder);

        vm.prank(owner);
        token.burnFrom(holder, 400);

        assertEq(
            token.totalSupply(),
            supplyBefore - (400 * 10 ** token.decimals())
        );

        assertEq(
            token.balanceOf(holder),
            balanceBefore - (400 * 10 ** token.decimals())
        );
    }

    function testNonOwnerCannotBurnFromAnotherAccount() public {
        address holder = address(0xCAFE);
        address attacker = address(0xBEEF);

        vm.prank(owner);
        token.mint(holder, 1_000);

        vm.prank(attacker);
        vm.expectRevert();

        token.burnFrom(holder, 100);
    }

    function testGetOwnerReturnsCorrectOwner() public view {
        assertEq(token.getOwner(), owner);
    }

    function testGetBalanceReturnsCorrectBalance() public view {
        assertEq(
            token.getBalance(owner),
            token.balanceOf(owner)
        );
    }

    function testExistsReturnsTrueForTokenHolder() public view {
        assertTrue(token.exists(owner));
    }

    function testExistsReturnsFalseForNonHolder() public view {
        address nonHolder = address(0xDEAD);

        assertFalse(token.exists(nonHolder));
    }

    function testGetTokenInfoReturnsCorrectData() public view {
        (
            string memory tokenName,
            string memory tokenSymbol,
            uint8 tokenDecimals,
            uint256 tokenSupply
        ) = token.getTokenInfo();

        assertEq(tokenName, "B20 Rocket");
        assertEq(tokenSymbol, "B20");
        assertEq(tokenDecimals, 18);
        assertEq(tokenSupply, token.totalSupply());
    }

    function testGetBalanceReturnsZeroForEmptyAccount() public view {
        address emptyAccount = address(0x1234);

        assertEq(token.getBalance(emptyAccount), 0);
    }

    function testCannotBurnMoreThanBalance() public {
        vm.prank(owner);
        vm.expectRevert();

        token.burn(2_000_000);
    }

    function testEmptyAccountCannotBurnTokens() public {
        address emptyAccount = address(0x5678);

        vm.prank(emptyAccount);
        vm.expectRevert();

        token.burn(100);
    }
}