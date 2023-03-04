// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import "forge-std/Test.sol";

import {VirtualSafeToken} from "src/VirtualSafeToken.sol";
import {Safe} from "lib/safe-contracts/contracts/Safe.sol";
import {SafeToken} from "lib/safe-token/contracts/SafeToken.sol";

contract VirtualSafeTokenTest is Test {
    using stdStorage for StdStorage;

    VirtualSafeToken internal constant token = VirtualSafeToken(0xa30010603857e547CF1AA74c7847B357B5fBF0d2);

    Safe internal constant safeTreasury = Safe(payable(0x8CF60B289f8d31F737049B590b5E4285Ff0Bd1D1));
    SafeToken internal constant safeToken = SafeToken(0x5aFE3855358E112B5647B952709E6165e1c1eEEe);
    uint256 internal constant safeTokenAmount = 1181.539172890329705987 * 1 ether;

    function setUp() public payable {
        // Create Ethereum fork.
        vm.createSelectFork(vm.rpcUrl("mainnet"));

        // Simulate setting guard to vSAFE.
        vm.prank(address(safeTreasury));
        safeTreasury.setGuard(address(token));
    }

    // VM Cheatcodes can be found in ./lib/forge-std/src/Vm.sol
    // or at https://github.com/foundry-rs/forge-std

    function testSafeTokenOwner() public payable {
        // We check our simulated Safe Token foundation treasury is Safe Token owner.
        assertEq(safeToken.owner(), address(safeTreasury));
    }

    function testSafeTokenBalance() public payable {
        // We check Safe treasury balance of Safe Token is current.
        assertEq(safeToken.balanceOf(address(safeTreasury)), safeTokenAmount);
    }

    function testSafeTokenPaused() public payable {
        // We check Safe Token is paused and non-transferable.
        assertTrue(safeToken.paused());
    }
    /*
    function testMintVSafeToken() public payable {
        // Mint virtual tokens equal to Safe Token.
        vm.prank(address(safeTreasury));
        token.mint();

        // Confirm virtual balance is equal to Safe Token.
        assertEq(token.balanceOf(address(safeTreasury)), safeTokenAmount);
    }

    function testCannotMintVSafeTokenTwice() public payable {
        // Mint virtual tokens equal to Safe Token.
        vm.prank(address(safeTreasury));
        token.mint();

        // Confirm virtual balance is equal to Safe Token.
        assertEq(token.balanceOf(address(safeTreasury)), safeTokenAmount);

        // We expect second mint to fail as already claimed.
        vm.prank(address(safeTreasury));
        vm.expectRevert("Already minted.");
        token.mint();

        // Confirm balance is unchanged.
        assertEq(token.balanceOf(address(safeTreasury)), safeTokenAmount);
    }
    */
}
