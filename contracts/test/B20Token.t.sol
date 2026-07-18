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

    function testOwnerExistsAfterBurningSomeTokens() public {
        vm.prank(owner);
        token.burn(100);

        assertTrue(token.exists(owner));
    }

    function testOwnerNoLongerExistsAfterBurningAllTokens() public {
        uint256 fullBalance = token.balanceOf(owner);

        vm.prank(owner);
        token.burn(1_000_000);

        assertFalse(token.exists(owner));
    }

    function testTotalSupplyDecreasesAfterBurn() public {
        uint256 supplyBefore = token.totalSupply();

        vm.prank(owner);
        token.burn(500);

        assertEq(
            token.totalSupply(),
            supplyBefore - (500 * 10 ** token.decimals())
        );
    }

    function testTotalSupplyIncreasesAfterMint() public {
        address holder = address(0xCAFE);
        uint256 supplyBefore = token.totalSupply();

        vm.prank(owner);
        token.mint(holder, 500);

        assertEq(
            token.totalSupply(),
            supplyBefore + (500 * 10 ** token.decimals())
        );
    }

    function testHolderExistsAfterReceivingMintedTokens() public {
        address newHolder = address(0xBEEF);

        vm.prank(owner);
        token.mint(newHolder, 500);

        assertTrue(token.exists(newHolder));
    }

    function testHolderBalanceIncreasesAfterMint() public {
        address newHolder = address(0xBEEF);
        uint256 balanceBefore = token.balanceOf(newHolder);

        vm.prank(owner);
        token.mint(newHolder, 500);

        assertEq(
            token.balanceOf(newHolder),
            balanceBefore + (500 * 10 ** token.decimals())
        );
    }

    function testOwnerBalanceDecreasesAfterBurn() public {
        uint256 balanceBefore = token.balanceOf(owner);

        vm.prank(owner);
        token.burn(500);

        assertEq(
            token.balanceOf(owner),
            balanceBefore - (500 * 10 ** token.decimals())
        );
    }

    function testMintedHolderBalanceIsCorrect() public {
        address newHolder = address(0xABCD);

        vm.prank(owner);
        token.mint(newHolder, 750);

        assertEq(
            token.balanceOf(newHolder),
            750 * 10 ** token.decimals()
        );
    }

    function testMintingTwiceAccumulatesBalance() public {
        address newHolder = address(0xD00D);

        vm.startPrank(owner);
        token.mint(newHolder, 300);
        token.mint(newHolder, 200);
        vm.stopPrank();

        assertEq(
            token.balanceOf(newHolder),
            500 * 10 ** token.decimals()
        );
    }

    function testMultipleMintsIncreaseTotalSupplyCorrectly() public {
        uint256 supplyBefore = token.totalSupply();

        vm.startPrank(owner);
        token.mint(address(0x1111), 300);
        token.mint(address(0x2222), 200);
        vm.stopPrank();

        assertEq(
            token.totalSupply(),
            supplyBefore + (500 * 10 ** token.decimals())
        );
    }

    function testMintToZeroAddressReverts() public {
        vm.prank(owner);
        vm.expectRevert();

        token.mint(address(0), 500);
    }

    function testBurnZeroTokensDoesNotChangeSupply() public {
        uint256 supplyBefore = token.totalSupply();

        vm.prank(owner);
        token.burn(0);

        assertEq(token.totalSupply(), supplyBefore);
    }

    function testBurnZeroTokensDoesNotChangeBalance() public {
        uint256 balanceBefore = token.balanceOf(owner);

        vm.prank(owner);
        token.burn(0);

        assertEq(token.balanceOf(owner), balanceBefore);
    }

    function testMintZeroTokensDoesNotChangeSupply() public {
        uint256 supplyBefore = token.totalSupply();

        vm.prank(owner);
        token.mint(address(0xBEEF), 0);

        assertEq(token.totalSupply(), supplyBefore);
    }

    function testMintZeroTokensDoesNotChangeBalance() public {
        address holder = address(0xBEEF);
        uint256 balanceBefore = token.balanceOf(holder);

        vm.prank(owner);
        token.mint(holder, 0);

        assertEq(token.balanceOf(holder), balanceBefore);
    }

    function testMintZeroTokensDoesNotCreateHolder() public {
        address newHolder = address(0xCAFE);

        vm.prank(owner);
        token.mint(newHolder, 0);

        assertFalse(token.exists(newHolder));
    }

    function testMintCreatesHolderWithPositiveBalance() public {
        address newHolder = address(0x1234);

        vm.prank(owner);
        token.mint(newHolder, 250);

        assertTrue(token.exists(newHolder));
        assertEq(
            token.balanceOf(newHolder),
            250 * 10 ** token.decimals()
        );
    }

    function testMintToExistingHolderAccumulatesBalance() public {
        address holder = address(0x5678);

        vm.startPrank(owner);
        token.mint(holder, 100);
        token.mint(holder, 150);
        vm.stopPrank();

        assertEq(
            token.balanceOf(holder),
            250 * 10 ** token.decimals()
        );
    }

    function testMintToExistingHolderKeepsHolderStatus() public {
        address holder = address(0x5678);

        vm.startPrank(owner);
        token.mint(holder, 100);
        token.mint(holder, 150);
        vm.stopPrank();

        assertTrue(token.exists(holder));
    }

    function testBurnAllTokensRemovesHolderStatus() public {
        uint256 ownerBalance = token.balanceOf(owner);
        uint256 amountToBurn = ownerBalance / (10 ** token.decimals());

        vm.prank(owner);
        token.burn(amountToBurn);

        assertEq(token.balanceOf(owner), 0);
        assertFalse(token.exists(owner));
    }

    function testPartialBurnKeepsHolderStatus() public {
        uint256 balanceBefore = token.balanceOf(owner);

        vm.prank(owner);
        token.burn(100);

        assertTrue(token.exists(owner));
        assertEq(
            token.balanceOf(owner),
            balanceBefore - (100 * 10 ** token.decimals())
        );
    }

    function testBurnOneTokenDecreasesBalanceCorrectly() public {
        uint256 balanceBefore = token.balanceOf(owner);

        vm.prank(owner);
        token.burn(1);

        assertEq(
            token.balanceOf(owner),
            balanceBefore - (1 * 10 ** token.decimals())
        );
    }

    function testBurnOneTokenDecreasesTotalSupplyCorrectly() public {
        uint256 supplyBefore = token.totalSupply();

        vm.prank(owner);
        token.burn(1);

        assertEq(
            token.totalSupply(),
            supplyBefore - (1 * 10 ** token.decimals())
        );
    }

    function testBurnMultipleTokensDecreasesBalanceCorrectly() public {
        uint256 balanceBefore = token.balanceOf(owner);

        vm.prank(owner);
        token.burn(250);

        assertEq(
            token.balanceOf(owner),
            balanceBefore - (250 * 10 ** token.decimals())
        );
    }

    function testBurnMultipleTokensDecreasesTotalSupplyCorrectly() public {
        uint256 supplyBefore = token.totalSupply();

        vm.prank(owner);
        token.burn(250);

        assertEq(
            token.totalSupply(),
            supplyBefore - (250 * 10 ** token.decimals())
        );
    }

    function testBurnMultipleTokensKeepsOwnerAsHolder() public {
        vm.prank(owner);
        token.burn(250);

        assertTrue(token.exists(owner));
    }

    function testBurnMultipleTokensReducesBalanceAndSupplyEqually() public {
        uint256 balanceBefore = token.balanceOf(owner);
        uint256 supplyBefore = token.totalSupply();

        vm.prank(owner);
        token.burn(300);

        uint256 burnedAmount = 300 * 10 ** token.decimals();

        assertEq(token.balanceOf(owner), balanceBefore - burnedAmount);
        assertEq(token.totalSupply(), supplyBefore - burnedAmount);
    }

    function testBurnMultipleTimesAccumulatesCorrectly() public {
        uint256 balanceBefore = token.balanceOf(owner);

        vm.startPrank(owner);
        token.burn(100);
        token.burn(200);
        vm.stopPrank();

        uint256 totalBurned = 300 * 10 ** token.decimals();

        assertEq(
            token.balanceOf(owner),
            balanceBefore - totalBurned
        );
    }

    function testBurnMultipleTimesDecreasesTotalSupplyCorrectly() public {
        uint256 supplyBefore = token.totalSupply();

        vm.startPrank(owner);
        token.burn(100);
        token.burn(200);
        vm.stopPrank();

        uint256 totalBurned = 300 * 10 ** token.decimals();

        assertEq(
            token.totalSupply(),
            supplyBefore - totalBurned
        );
    }

    function testBurnMultipleTimesKeepsOwnerAsHolder() public {
        vm.startPrank(owner);
        token.burn(100);
        token.burn(200);
        vm.stopPrank();

        assertTrue(token.exists(owner));
    }

    function testBurnThenMintRestoresBalanceCorrectly() public {
        uint256 balanceBefore = token.balanceOf(owner);

        vm.startPrank(owner);
        token.burn(200);
        token.mint(owner, 200);
        vm.stopPrank();

        assertEq(token.balanceOf(owner), balanceBefore);
    }

    function testBurnThenMintRestoresTotalSupplyCorrectly() public {
        uint256 supplyBefore = token.totalSupply();

        vm.startPrank(owner);
        token.burn(200);
        token.mint(owner, 200);
        vm.stopPrank();

        assertEq(token.totalSupply(), supplyBefore);
    }

    function testBurnThenMintRestoresHolderStatusCorrectly() public {
        uint256 ownerBalance = token.balanceOf(owner);
        uint256 amountToBurn = ownerBalance / (10 ** token.decimals());

        vm.startPrank(owner);
        token.burn(amountToBurn);

        assertFalse(token.exists(owner));

        token.mint(owner, amountToBurn);
        vm.stopPrank();

        assertTrue(token.exists(owner));
    }

    function testBurnThenMintRestoresOriginalBalanceAndSupply() public {
        uint256 balanceBefore = token.balanceOf(owner);
        uint256 supplyBefore = token.totalSupply();

        vm.startPrank(owner);
        token.burn(300);
        token.mint(owner, 300);
        vm.stopPrank();

        assertEq(token.balanceOf(owner), balanceBefore);
        assertEq(token.totalSupply(), supplyBefore);
    }

    function testMintAfterFullBurnCreatesHolderAgain() public {
        uint256 ownerBalance = token.balanceOf(owner);
        uint256 amountToBurn = ownerBalance / (10 ** token.decimals());

        vm.startPrank(owner);
        token.burn(amountToBurn);

        assertFalse(token.exists(owner));

        token.mint(owner, 1);
        vm.stopPrank();

        assertTrue(token.exists(owner));
        assertEq(token.balanceOf(owner), 1 * 10 ** token.decimals());
    }

    function testMintAfterFullBurnRestoresTotalSupplyByMintedAmount() public {
        uint256 ownerBalance = token.balanceOf(owner);
        uint256 amountToBurn = ownerBalance / (10 ** token.decimals());
        uint256 supplyBefore = token.totalSupply();

        vm.startPrank(owner);
        token.burn(amountToBurn);
        token.mint(owner, 50);
        vm.stopPrank();

        assertEq(
            token.totalSupply(),
            supplyBefore - ownerBalance + (50 * 10 ** token.decimals())
        );
    }

    function testMintAfterFullBurnIncreasesSupplyFromZero() public {
        uint256 ownerBalance = token.balanceOf(owner);
        uint256 amountToBurn = ownerBalance / (10 ** token.decimals());

        vm.startPrank(owner);
        token.burn(amountToBurn);

        assertEq(token.totalSupply(), 0);

        token.mint(owner, 100);
        vm.stopPrank();

        assertEq(
            token.totalSupply(),
            100 * 10 ** token.decimals()
        );
    }

    function testMintAfterFullBurnRestoresExactBalance() public {
        uint256 ownerBalance = token.balanceOf(owner);
        uint256 amountToBurn = ownerBalance / (10 ** token.decimals());

        vm.startPrank(owner);
        token.burn(amountToBurn);
        token.mint(owner, 75);
        vm.stopPrank();

        assertEq(
            token.balanceOf(owner),
            75 * 10 ** token.decimals()
        );
    }

    function testMintAfterFullBurnRestoresHolderWithCorrectSupply() public {
        uint256 ownerBalance = token.balanceOf(owner);
        uint256 amountToBurn = ownerBalance / (10 ** token.decimals());

        vm.startPrank(owner);
        token.burn(amountToBurn);

        assertFalse(token.exists(owner));
        assertEq(token.totalSupply(), 0);

        token.mint(owner, 25);
        vm.stopPrank();

        assertTrue(token.exists(owner));
        assertEq(token.balanceOf(owner), 25 * 10 ** token.decimals());
        assertEq(token.totalSupply(), 25 * 10 ** token.decimals());
    }

    function testMintAfterFullBurnRestoresSupplyAndHolderTogether() public {
        uint256 ownerBalance = token.balanceOf(owner);
        uint256 amountToBurn = ownerBalance / (10 ** token.decimals());

        vm.startPrank(owner);
        token.burn(amountToBurn);

        assertFalse(token.exists(owner));
        assertEq(token.totalSupply(), 0);

        token.mint(owner, 50);
        vm.stopPrank();

        assertTrue(token.exists(owner));
        assertEq(token.balanceOf(owner), 50 * 10 ** token.decimals());
        assertEq(token.totalSupply(), 50 * 10 ** token.decimals());
    }

    function testMintAfterFullBurnRestoresStateWithDifferentAmount() public {
        uint256 ownerBalance = token.balanceOf(owner);
        uint256 amountToBurn = ownerBalance / (10 ** token.decimals());

        vm.startPrank(owner);
        token.burn(amountToBurn);

        assertFalse(token.exists(owner));
        assertEq(token.totalSupply(), 0);

        token.mint(owner, 125);
        vm.stopPrank();

        assertTrue(token.exists(owner));
        assertEq(token.balanceOf(owner), 125 * 10 ** token.decimals());
        assertEq(token.totalSupply(), 125 * 10 ** token.decimals());
    }

    function testMintAfterFullBurnCanRestoreDifferentHolder() public {
        address newHolder = address(0xABCD);
        uint256 ownerBalance = token.balanceOf(owner);
        uint256 amountToBurn = ownerBalance / (10 ** token.decimals());

        vm.startPrank(owner);
        token.burn(amountToBurn);
        token.mint(newHolder, 200);
        vm.stopPrank();

        assertFalse(token.exists(owner));
        assertTrue(token.exists(newHolder));
        assertEq(
            token.balanceOf(newHolder),
            200 * 10 ** token.decimals()
        );
    }

    function testMintToDifferentHolderAfterFullBurnUpdatesTotalSupply() public {
        address newHolder = address(0xCAFE);
        uint256 ownerBalance = token.balanceOf(owner);
        uint256 amountToBurn = ownerBalance / (10 ** token.decimals());

        vm.startPrank(owner);
        token.burn(amountToBurn);
        token.mint(newHolder, 300);
        vm.stopPrank();

        assertEq(
            token.totalSupply(),
            300 * 10 ** token.decimals()
        );
    }

    function testMintToDifferentHolderAfterFullBurnLeavesOwnerBalanceAtZero() public {
        address newHolder = address(0xD00D);
        uint256 ownerBalance = token.balanceOf(owner);
        uint256 amountToBurn = ownerBalance / (10 ** token.decimals());

        vm.startPrank(owner);
        token.burn(amountToBurn);
        token.mint(newHolder, 150);
        vm.stopPrank();

        assertEq(token.balanceOf(owner), 0);
        assertFalse(token.exists(owner));
        assertTrue(token.exists(newHolder));
    }
}