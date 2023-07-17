// SPDX-License-Identifier: MIT

pragma solidity >=0.8.19;


// selfdestruct命令可以用来删除智能合约，并将该合约剩余ETH转到指定地址。selfdestruct是为了应对合约出错的极端情况而设计的。
// 它最早被命名为suicide（自杀），但是这个词太敏感。为了保护抑郁的程序员，改名为selfdestruct。

contract DeleteContract{
    uint public value = 10;
      constructor() payable {}

    receive() external payable {}

    function deleteContract()external {
        selfdestruct(payable(msg.sender));
    }

    function getBalance() external view returns(uint balance){
        balance = address(this).balance;
    }
}