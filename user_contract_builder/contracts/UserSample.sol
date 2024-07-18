// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";

contract UserSample {
    using SafeERC20 for IERC20;
    address public relayAddress;

    IERC20 public usdcToken;

    constructor(address _relayAddress, address _token) {
        relayAddress = _relayAddress;
        usdcToken = IERC20(_token);
    }

    function relayJob(
        bytes32 _codehash,
        bytes memory _codeInputs,
        uint256 _userTimeout,
        uint256 _maxGasPrice,
        uint256 _usdcDeposit,
        address _refundAccount,
        address _callbackContract,
        uint256 _callbackGasLimit
    ) external payable returns (bool) {
        usdcToken.safeIncreaseAllowance(relayAddress, _usdcDeposit);

        (bool success, ) = relayAddress.call{value: msg.value}(
            abi.encodeWithSignature(
                "relayJob(bytes32,bytes,uint256,uint256,address,address,uint256)",
                _codehash,
                _codeInputs,
                _userTimeout,
                _maxGasPrice,
                _refundAccount,
                _callbackContract,
                _callbackGasLimit
            )
        );
        return success;
    }

    event CalledBack(
        uint256 indexed jobId,
        address jobOwner, 
        bytes32 codehash,
        bytes codeInputs,
        bytes outputs, 
        uint8 errorCode
    );

    function oysterResultCall(
        uint256 _jobId,
        address _jobOwner,
        bytes32 _codehash,
        bytes calldata _codeInputs,
        bytes calldata _output, 
        uint8 _errorCode
    ) public {
        emit CalledBack(_jobId, _jobOwner, _codehash, _codeInputs, _output, _errorCode);
    }

    receive() external payable {}
}

