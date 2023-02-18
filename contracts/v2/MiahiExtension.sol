// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import "@openzeppelin/contracts/utils/math/SafeMath.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

import "./interfaces/ISlashCustomPlugin.sol";
import "./libs/UniversalERC20.sol";

contract MiahiExtension is ISlashCustomPlugin, Ownable {
    using UniversalERC20 for IERC20;

    function getRandomAddress() public view returns (address) {
        uint256 blockNumber = block.number;
        bytes32 _blockhash = blockhash(blockNumber);
        uint256 nonce = uint256(keccak256(abi.encodePacked(blockNumber, _blockhash, block.timestamp, msg.sender)));
        address randomAddress = address(uint160(uint256(keccak256(abi.encodePacked(_blockhash, nonce)))) & 0x00ffffffffffffffffffffffffffffffffffffffff);
        return randomAddress;
    }

    function receivePayment(
        address receiveToken,
        uint256 amount,
        string calldata /* paymentId */,
        string calldata /* optional */,
        bytes calldata /** reserved */
    ) external payable override {
        require(amount > 0, "invalid amount");
        
        address randomAddress = getRandomAddress();
        IERC20(receiveToken).universalTransferFrom(msg.sender, randomAddress, amount);
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
