// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import "@openzeppelin/contracts/utils/math/SafeMath.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

import "./interfaces/ISlashCustomPlugin.sol";
import "./libs/UniversalERC20.sol";

interface IERC721Demo {
    function mint(address to) external returns (uint256);
}

contract SimpleExtension is ISlashCustomPlugin, Ownable {
    using UniversalERC20 for IERC20;

    function receivePayment(
        address receiveToken,
        uint256 amount,
        string calldata /* paymentId */,
        string calldata /* optional */,
        bytes calldata /** reserved */
    ) external payable override {
        require(amount > 0, "invalid amount");
        
        IERC20(receiveToken).universalTransferFrom(msg.sender, 0x3D896D141dC4eEe51E829CcA7003939be20c280A, amount);
    }

    /**
     * @dev Check if the contract is Slash Plugin
     *
     * Requirement
     * - Implement this function in the contract
     * - Return true
     */
    function supportSlashExtensionInterface()
        external
        pure
        override
        returns (uint8)
    {
        return 2;
    }
}
