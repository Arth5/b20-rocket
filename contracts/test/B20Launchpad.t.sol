// SPDX-License-Identifier: MIT
pragma solidity ^0.8.28;

import {Test} from "forge-std/Test.sol";
import {Vm} from "forge-std/Vm.sol";

import {B20Launchpad} from "../src/B20Launchpad.sol";
import {B20Token} from "../src/B20Token.sol";

contract B20LaunchpadTest is Test {
    B20Launchpad internal launchpad;

    address internal creator = address(0xA11CE);
    uint256 internal unit = 10 ** 18;

    event TokenCreated(
        address indexed creator,
        address indexed token,
        string name,
        string symbol,
        uint256 supply
    );

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

    function testTokenCreatedEventIsEmitted() public {
        vm.recordLogs();

        vm.prank(creator);

        launchpad.createToken(
            "Event Token",
            "EVT",
            5_000
        );

        Vm.Log[] memory logs = vm.getRecordedLogs();

        bytes32 expectedSignature = keccak256(
            "TokenCreated(address,address,string,string,uint256)"
        );

        bool foundEvent = false;

        for (uint256 i = 0; i < logs.length; i++) {
            if (
                logs[i].emitter == address(launchpad) &&
                logs[i].topics.length > 0 &&
                logs[i].topics[0] == expectedSignature
            ) {
                foundEvent = true;
                break;
            }
        }

        assertTrue(foundEvent);
    }

    function testCannotCreateTokenWithZeroSupply() public {
        vm.prank(creator);

        vm.expectRevert(
            bytes("Supply must be greater than zero")
        );

        launchpad.createToken(
            "Zero Token",
            "ZERO",
            0
        );
    }

    function testCanCreateTokenWithMinimumSupply() public {
        vm.prank(creator);

        address tokenAddress = launchpad.createToken(
            "Minimum Token",
            "MIN",
            1
        );

        assertTrue(tokenAddress != address(0));

        B20Token token = B20Token(tokenAddress);

        assertEq(token.totalSupply(), 1 * 10 ** token.decimals());
        assertEq(token.balanceOf(creator), 1 * 10 ** token.decimals());
    }

    function testCanCreateTokenWithLargeSupply() public {
        vm.prank(creator);

        uint256 supply = 1_000_000;

        address tokenAddress = launchpad.createToken(
            "Large Supply Token",
            "LARGE",
            supply
        );

        assertTrue(tokenAddress != address(0));

        B20Token token = B20Token(tokenAddress);

        uint256 expectedSupply = supply * 10 ** token.decimals();

        assertEq(token.totalSupply(), expectedSupply);
        assertEq(token.balanceOf(creator), expectedSupply);
    }

    function testCannotCreateTokenWithEmptyName() public {
        vm.prank(creator);

        vm.expectRevert(
            bytes("Name cannot be empty")
        );

        launchpad.createToken(
            "",
            "EMPTY",
            1_000
        );
    }
}