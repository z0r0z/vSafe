// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import {Script} from "forge-std/Script.sol";

import {VirtualSafeToken} from "src/VirtualSafeToken.sol";

/// @notice A very simple deployment script.
contract Deploy is Script {
    /// @notice The main script entrypoint.
    /// @return token The deployed contract.
    function run() public virtual returns (VirtualSafeToken token) {
        vm.startBroadcast();
        token = new VirtualSafeToken();
        vm.stopBroadcast();
    }
}
