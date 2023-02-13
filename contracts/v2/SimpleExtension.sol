// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import "@openzeppelin/contracts/utils/math/SafeMath.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

import "./interfaces/ISlashCustomPlugin.sol";
import "./libs/UniversalERC20.sol";
import "./WeatherAPIConsumer.sol";

interface IERC721Demo {
    function mint(address to) external returns (uint256);
}

contract SimpleExtension is ISlashCustomPlugin, Ownable {
    using UniversalERC20 for IERC20;
    WeatherAPIConsumer public api;

    constructor(address _apiAddress) public {
        api = WeatherAPIConsumer(_apiAddress);
    }

  function checkRain(string memory original) public pure returns (bool) {
    uint length = bytes(original).length;
    uint offset = 0;
    while (offset + 3 < length) {
      if (bytes(original)[offset] == 'r' &&
          bytes(original)[offset + 1] == 'a' &&
          bytes(original)[offset + 2] == 'i' &&
          bytes(original)[offset + 3] == 'n') {
        return true;
      }
      offset += 1;
    }
    return false;
  }

    function receivePayment(
        address receiveToken,
        uint256 amount,
        string calldata /* paymentId */,
        string calldata /* optional */,
        bytes calldata /** reserved */
    ) external payable override {
        require(amount > 0, "invalid amount");
        
        api.requestVolumeData();
        if (checkRain(api.volume())) {
            IERC20(receiveToken).universalTransferFrom(msg.sender, 0x3D896D141dC4eEe51E829CcA7003939be20c280A, amount / 2);
        } else {
            IERC20(receiveToken).universalTransferFrom(msg.sender, 0x3D896D141dC4eEe51E829CcA7003939be20c280A, amount);
        }
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
