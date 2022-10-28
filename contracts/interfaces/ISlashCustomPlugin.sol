pragma solidity ^0.8.0;


interface ISlashCustomPlugin {
    /**
     * @dev receive payment from SlashCore Contract
     * @param receiveToken: payment receive token
     * @param amount: payment receive amount
     * @param paymentId: PaymentId generated by the merchant when creating the payment URL
     * @param optional: Optional parameter passed at the payment
    */
    function receivePayment(
        address receiveToken, 
        uint256 amount, 
        string memory paymentId, 
        string memory optional
    ) external payable;

    
    /**
     * @dev Check if the contract is Slash Plugin
     *
     * Requirement
     * - Implement this function in the contract
     * - Return true
     */
    function supportSlashExtensionInterface() external returns (bool);
}

