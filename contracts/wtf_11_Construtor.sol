// SPDX-License-Identifier: MIT
pragma solidity >=0.8.19;




contract constructorAndModifier {

    address owner;

    //修饰器：要求调用者必须是owner
    modifier OnlyOwner {
        require(msg.sender == owner);
         _;
    }

    //构造函数，在合约初始化时调用一次
    constructor(){
        owner = msg.sender;
    }


    //使用OnlyOwner修饰器的function
    function changeOwner(address newOwner) public OnlyOwner{
        owner = newOwner;
    }

}