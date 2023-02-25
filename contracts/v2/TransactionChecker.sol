pragma solidity ^0.8.0;

contract TransactionChecker {
    
    mapping(address => uint256[]) public userTransactions;
    mapping(address => uint256) public userAverage;
    
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
}
