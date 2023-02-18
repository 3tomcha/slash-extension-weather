pragma solidity ^0.8.0;

contract RandomAddress {
    function getRandomAddress() public view returns (address) {
        uint256 blockNumber = block.number;
        bytes32 blockhash = blockhash(blockNumber);
        uint256 nonce = uint256(keccak256(abi.encodePacked(blockNumber, blockhash, block.timestamp, msg.sender)));
        address randomAddress = address(uint160(uint256(keccak256(abi.encodePacked(blockhash, nonce)))) & 0x00ffffffffffffffffffffffffffffffffffffffff);
        return randomAddress;
    }
}
