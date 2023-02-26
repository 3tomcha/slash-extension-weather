// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/ERC1155/IERC1155.sol";
import "@openzeppelin/contracts/token/ERC1155/IERC1155Receiver.sol";

import "./interfaces/ISlashCustomPlugin.sol";
import "./libs/UniversalERC20.sol";
import "./IYHSBT.sol";

contract IYHExtension is ISlashCustomPlugin, Ownable {
    using UniversalERC20 for IERC20;

    mapping(address => uint256[]) public userTransactions;
    mapping(address => uint256) public userAverage;
    
    event IYH (address indexed from, uint256 averageAmount, uint256 amount);

    function isTransactionAmountValid(address _user, uint256 _transactionAmount) public view returns(bool) {
        if (_transactionAmount > (userAverage[_user] * 10)) {
            return true;
        }
        return false;
    }
    
    function addTransaction(address _user, uint256 _transactionAmount) public {
        userTransactions[_user].push(_transactionAmount);
        uint256 sum = 0;
        uint256 transactionCount = userTransactions[_user].length;
        if (transactionCount == 0) {
            userAverage[_user] = _transactionAmount;
        } else {
            for (uint256 i = 0; i < transactionCount; i++) {
                sum += userTransactions[_user][i];
            }
            userAverage[_user] = sum / transactionCount;
        }
    }

    function receivePayment(
        address receiveToken_,
        uint256 amount_,
        string calldata /* paymentId */,
        string calldata /* optional */,
        bytes calldata /** reserved */
    ) external payable {
        require(amount_ > 0, "invalid amount");
        addTransaction(msg.sender, amount_);
        if (isTransactionAmountValid(msg.sender, amount_)) {
            emit IYH(msg.sender, userAverage[msg.sender], amount_);
        }
        IYHSBT(0x64E012c92BDA3e9528a9c4858D878aF490d32A69).mintNFT(msg.sender, "ipfs://Qme97gSuKjwSToTjZdhBQeQzmvwgzkw32RyqgnwRpsTPSh");
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
        returns (uint8)
    {
        return 2;
    }
}
