// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import "forge-std/Test.sol";

import {VirtualSafeToken} from "src/VirtualSafeToken.sol";

contract VirtualSafeTokenTest is Test {
    using stdStorage for StdStorage;

    VirtualSafeToken token;

    function setUp() public payable {
        token = new VirtualSafeToken();
    }

    // VM Cheatcodes can be found in ./lib/forge-std/src/Vm.sol
    // Or at https://github.com/foundry-rs/forge-std

    function testClaim() external {}
}
