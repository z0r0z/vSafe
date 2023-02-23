// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import {Enum, BaseGuard} from "lib/safe-contracts/contracts/base/GuardManager.sol";
import {ERC20} from "solmate/tokens/ERC20.sol";

/// @title Virtual Safe Token.
/// @author z0r0z.eth
/// @custom:coauthor ellie.lens
/// @notice Makes Safe Token opt-in transferable through tx guard.
/// Users can mint vSAFE by locking their SAFE while it is paused.
/// @dev Includes improvements such as ERC2612 and gas golfing.
contract VirtualSafeToken is BaseGuard, ERC20("Virtual Safe Token", "vSAFE", 18) {
    /// @dev Canonical deployment of Safe Token on Ethereum.
    address internal constant safeToken = 0x5aFE3855358E112B5647B952709E6165e1c1eEEe;

    /// @dev Tracks claims by Safes.
    mapping( /*safe*/ address => /*mint*/ bool) public minted;

    /// @dev We can cut 10 opcodes in the creation-time
    /// EVM bytecode by declaring constructor payable.
    constructor() payable {}

    /// @dev We don't revert on fallback to avoid issues in case of a Safe upgrade -
    /// e.g., the expected check method might change and then the Safe would be locked.
    fallback() external {}

    /// @dev Fetches whether Safe Token is paused.
    function paused() public view returns (bool) {
        return VirtualSafeToken(safeToken).paused();
    }

    /// @dev Mints unclaimed vSAFE to SAFE holders.
    function mint() external payable {
        if (!minted[msg.sender]) {
            _mint(msg.sender, ERC20(safeToken).balanceOf(msg.sender));
        }
    }

    /// @dev Called by the Safe contract before a transaction is executed.
    /// Reverts if the transaction comes from a Safe after token unlock.
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
        view
        override
    {
        if (to == address(this)) {
            require(paused(), "This call is restricted");
        } else {
            require(to != address(safeToken), "This call is restricted");
        }
    }

    /// @dev Placeholder to receive after-execution check from a Safe.
    function checkAfterExecution(bytes32, bool) external view override {}
}
