// SPDX-License-Identifier: MIT

pragma solidity >=0.8.19;

//这个合约有选择器冲突，有选择器冲突的问题，存在安全隐患。之后我们会介绍解决这一隐患的可升级合约标准：透明代理和UUPS。
contract Proxy {
    address public implementation; //逻辑合约地址
    address public admin; //管理员地址
    string public words; //数据，可通过逻辑合约的函数改变

    constructor(address _impl){
        implementation = _impl;
        admin = msg.sender;
    }

    fallback()external  payable {
        (bool success, bytes memory data) = implementation.delegatecall(msg.data);
    }

    //升级合约：将逻辑合约地址指向新的合约地址
    function upgrade(address _impl)external {
        require(msg.sender == admin);
        implementation = _impl; 
    }

}

contract Logic1{
    //状态变量要和proxy合约一致，防止插槽冲突
    address public implementation; //逻辑合约地址
    address public admin; //管理员地址
    string public words; //数据，可通过逻辑合约的函数改变

    function foo()public{
        words = "logic1";
    }
}


contract Logic2{
    //状态变量要和proxy合约一致，防止插槽冲突
    address public implementation; //逻辑合约地址
    address public admin; //管理员地址
    string public words; //数据，可通过逻辑合约的函数改变

    function foo()public{
        words = "logic2";
    }
}