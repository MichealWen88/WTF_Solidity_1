// SPDX-License-Identifier: MIT

pragma solidity >=0.8.19;

import "./wtf_31_ERC20.sol";


contract Faucet{
    uint256 public amountAllowed = 100;//每次可领取的水数量
    address public tokenContract; //token合约地址
    mapping (address=>bool) public requestedAddress;

    event SendToken(address indexed Receiver,uint256 Amount);

    constructor(address _tokenContract){
        tokenContract = _tokenContract;
    }

    function requestToken()external {
        require(requestedAddress[msg.sender] == false,"Already requested");
        IERC20 token = IERC20(tokenContract);
        require(token.balanceOf(address(this))> 0,"Faucet is empty.");
        token.transfer(msg.sender,amountAllowed);
        requestedAddress[msg.sender] = true;
        emit SendToken(msg.sender, amountAllowed);
    }

}

