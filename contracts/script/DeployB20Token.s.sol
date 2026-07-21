// SPDX-License-Identifier: MIT
pragma solidity ^0.8.28;

import {Script} from "forge-std/Script.sol";
import {B20Token} from "../src/B20Token.sol";

contract DeployB20Token is Script {
    function run() external returns (B20Token token) {
        address initialOwner = vm.envAddress("INITIAL_OWNER");

        vm.startBroadcast();

        token = new B20Token(
            "B20 Rocket Test",
            "B20T",
            1_000_000,
            initialOwner
        );

        vm.stopBroadcast();
    }
}