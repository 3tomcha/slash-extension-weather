// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import "@openzeppelin/contracts-upgradeable/access/OwnableUpgradeable.sol";

import "./libs/UniversalERC20.sol";

contract IYHExtension is OwnableUpgradeable {
    using UniversalERC20 for IERC20Upgradeable;

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
        IERC20Upgradeable(receiveToken_).universalTransferFromSenderToThis(
            amount_
        );
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
