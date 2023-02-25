// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import {Enum, BaseGuard} from "lib/safe-contracts/contracts/base/GuardManager.sol";
import {ERC20} from "solmate/tokens/ERC20.sol";

/// @title Virtual Safe Token.
/// @author z0r0z.eth
/// @custom:coauthor ellie.lens
/// @notice Makes Safe Token opt-in transferable through tx guard.
/// Users can mint vSAFE equal to their SAFE while it is paused.
/// @dev Includes improvements such as ERC2612 and gas golfing.
contract VirtualSafeToken is BaseGuard, ERC20("Virtual Safe Token", "vSAFE", 18) {
    /// @dev Canonical deployment of Safe Token on Ethereum.
    address internal constant safeToken = 0x5aFE3855358E112B5647B952709E6165e1c1eEEe;

    /// @dev Internal flag to ensure this guard is enabled.
    uint256 internal guardCheck = 1;

    /// @dev Tracks mint claims by Safes.
    mapping( /*safe*/ address => /*mint*/ bool) public minted;

    /// @dev We can cut 10 opcodes in the creation-time
    /// EVM bytecode by declaring constructor payable.
    constructor() payable {}

    /// @dev Fetches whether Safe Token is paused.
    function paused() public view returns (bool) {
        return VirtualSafeToken(safeToken).paused();
    }

    /// @dev Mints unclaimed vSAFE to SAFE holders.
    function mint() public payable {
        // Ensure this call is by guarded Safe.
        require(guardCheck == 2, "Unguarded.");

        // Reset guard value.
        guardCheck = 1;

        // Ensure no mint during transferable period.
        require(paused(), "Unpaused.");

        // Ensure no double mint and mint balance of Safe Token.
        if (minted[msg.sender] = true == !minted[msg.sender]) {
            _mint(msg.sender, ERC20(safeToken).balanceOf(msg.sender));
        }
    }

    /// @dev Burn an amount of vSAFE.
    function burn(uint256 amount) public payable {
        _burn(msg.sender, amount);
    }

    /// @dev Called by the Safe contract before a transaction is executed.
    /// Reverts if the transaction is to a Safe during Safe Token lock.
    /// @param to Destination address of the Safe transaction.
    function checkTransaction(
        address to,
        uint256,
        bytes memory,
        Enum.Operation,
        uint256,
        uint256,
        uint256,
        address,
        address payable,
        bytes memory,
        address
    )
        external
        override
    {
        // Ensure mint by guarded Safe.
        if (to == address(this)) {
            guardCheck = 2;
        } else if (to == msg.sender) {
            // If callback to Safe,
            // prevent disabling guard
            // while Safe Token is locked.
            require(!paused(), "Paused.");
        }
    }

    /// @dev Placeholder for after-execution check in Safe guard.
    function checkAfterExecution(bytes32, bool) external view override {}
}
