// SPDX-License-Identifier: MIT

pragma solidity >=0.8.19;

import "@openzeppelin/contracts/proxy/transparent/TransparentUpgradeableProxy.sol";

// 合约存在两个选择器相同的函数，可能会造成严重后果。作为透明代理的替代方案，UUPS也能解决这一问题。

// UUPS（universal upgradeable proxy standard，通用可升级代理）将升级函数放在逻辑合约中。这样一来，如果有其它函数与升级函数存在“选择器冲突”，编译时就会报错。

// 下表中概括了普通可升级合约，透明代理，和UUPS的不同点：


//代理合约不包含升级函数
contract UUPSProxy{
    address public implementation; //逻辑合约地址
    address public admin; //管理员地址
    string public words; //数据，可通过逻辑合约的函数改变

    constructor(address _impl){
        implementation = _impl;
        admin = msg.sender;
    }

    fallback()external  payable {
        implementation.delegatecall(msg.data);
    }
}

contract UUPS1{
    address public implementation; //逻辑合约地址
    address public admin; //管理员地址
    string public words; //数据，可通过逻辑合约的函数改变

    //升级合约：将逻辑合约地址指向新的合约地址
    function upgrade(address _impl)external {
        require(msg.sender == admin);
        implementation = _impl; 
    }

     function foo()public{
        words = "UUPS1";
    }
}

contract UUPS2{
    address public implementation; //逻辑合约地址
    address public admin; //管理员地址
    string public words; //数据，可通过逻辑合约的函数改变

    //升级合约：将逻辑合约地址指向新的合约地址
    function upgrade(address _impl)external {
        require(msg.sender == admin);
        implementation = _impl; 
    }

     function foo()public{
        words = "UUPS2";
    }
}