// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import {Enum, BaseGuard} from "lib/safe-contracts/contracts/base/GuardManager.sol";
import {ERC20} from "solmate/tokens/ERC20.sol";

/// @title Virtual Safe Token.
/// @author z0r0z.eth
/// @custom:coauthor ellie.lens
/// @notice Makes Safe Token (SAFE) opt-in transferable through tx guard.
/// Users can mint vSAFE equal to their SAFE while it is paused.
/// SAFE can be reclaimed from vSAFE pool by burning vSAFE.
contract VirtualSafeToken is BaseGuard, ERC20("Virtual Safe Token", "vSAFE", 18) {
    /// @dev Canonical deployment of SAFE on Ethereum.
    address internal constant safeToken = 0x5aFE3855358E112B5647B952709E6165e1c1eEEe;

    /// @dev Internal flag to ensure this guard is enabled.
    uint256 internal guardCheck = 1;

    /// @dev Tracks mint claims by Safes.
    mapping( /*safe*/ address => /*mint*/ bool) public minted;

    /// @dev We can cut 10 opcodes in the creation-time
    /// EVM bytecode by declaring constructor payable.
    constructor() payable {}

    /// @dev Fetches whether SAFE is paused.
    function paused() public view returns (bool) {
        return VirtualSafeToken(safeToken).paused();
    }

    /// @dev Mints unclaimed vSAFE to SAFE holders.
    function mint(address to) public payable {
        // Ensure this call is by guarded Safe.
        require(guardCheck == 2, "Unguarded.");

        // Reset guard value.
        guardCheck = 1;

        // Ensure no mint during transferable period.
        require(paused(), "Unpaused.");

        // Ensure that SAFE custody is given to vSAFE to fund reclaiming.
        require(VirtualSafeToken(safeToken).allowance(msg.sender, address(this)) == type(uint256).max, "Unapproved.");

        // Ensure no double mint and mint vSAFE per SAFE balance.
        if (minted[msg.sender] = true == !minted[msg.sender]) {
            _mint(to, ERC20(safeToken).balanceOf(msg.sender));
        }
    }

    /// @dev Burn an amount of vSAFE.
    function burn(uint256 amount) public payable {
        _burn(msg.sender, amount);
    }

    /// @dev Burn an amount of vSAFE to reclaim SAFE.
    function reclaim(address from, uint256 amount) public payable {
        VirtualSafeToken(safeToken).transferFrom(from, msg.sender, amount);

        _burn(msg.sender, amount);
    }

    /// @dev Called by a Safe contract before a transaction is executed.
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
        } else {
            // Ensure no callbacks or calls to SAFE.
            require(to != msg.sender, "Restricted.");
            require(to != safeToken, "Restricted.");
        }
    }

    /// @dev Placeholder for after-execution check in Safe guard.
    function checkAfterExecution(bytes32, bool) external view override {}
}
