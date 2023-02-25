// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import "@openzeppelin/contracts/utils/math/SafeMath.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

import "./interfaces/ISlashCustomPlugin.sol";
import "./libs/UniversalERC20.sol";

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
        address receiveToken,
        uint256 amount,
        string calldata /* paymentId */,
        string calldata /* optional */,
        bytes calldata /** reserved */
    ) external payable override {
        require(amount > 0, "invalid amount");
        addTransaction(msg.sender, amount);
        if (isTransactionAmountValid(msg.sender, amount)) {
            emit IYH(msg.sender, userAverage[msg.sender], amount);
        }
        IERC20(receiveToken).universalTransferFrom(msg.sender, owner(), amount);
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
