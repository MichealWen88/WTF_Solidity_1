// SPDX-License-Identifier: MIT

pragma solidity >=0.8.19;

// 智能合约中，函数选择器（selector）是函数签名的哈希的前4个字节。
// 例如mint(address account)的选择器为bytes4(keccak256("mint(address)"))，也就是0x6a627842。
// 由于函数选择器仅有4个字节，范围很小，因此两个不同的函数可能会有相同的选择器，例如下面两个函数：

contract foo{

    bytes4 public selector1 = bytes4(keccak256("burn(uint256)"));
    bytes4 public selector2 = bytes4(keccak256("collate_propagate_storage(bytes16)"));


    //选择器冲突，两个方法的selector相同，编译会报错

    // function burn(uint256)external {}
    // function collate_propagate_storage(bytes16)external {}
}

// 由于代理合约和逻辑合约是两个合约，就算他们之间存在“选择器冲突”也可以正常编译，这可能会导致很严重的安全事故。举个例子，如果逻辑合约的a函数和代理合约的升级函数的选择器相同，那么管理人就会在调用a函数的时候，将代理合约升级成一个黑洞合约，后果不堪设想。

// 目前，有两个可升级合约标准解决了这一问题：透明代理Transparent Proxy和通用可升级代理UUPS。

//透明代理
// 透明代理的逻辑非常简单：管理员可能会因为“函数选择器冲突”，在调用逻辑合约的函数时，误调用代理合约的可升级函数。那么限制管理员的权限，不让他调用任何逻辑合约的函数，就能解决冲突：

// 管理员变为工具人，仅能调用代理合约的可升级函数对合约升级，不能通过回调函数调用逻辑合约。
// 其它用户不能调用可升级函数，但是可以调用逻辑合约的函数。

// 这一讲，我们介绍了代理合约中的“选择器冲突”，以及如何利用透明代理避免这个问题。
// 透明代理的逻辑简单，通过限制管理员调用逻辑合约解决“选择器冲突”问题。
// 它也有缺点，每次用户调用函数时，都会多一步是否为管理员的检查，消耗更多gas。但瑕不掩瑜，透明代理仍是大多数项目方选择的方案。

contract TransparentProxy{
    address public implementation; //逻辑合约地址
    address public admin; //管理员地址
    string public words; //数据，可通过逻辑合约的函数改变

    constructor(address _impl){
        implementation = _impl;
        admin = msg.sender;
    }

    fallback()external  payable {
        //管理员只能调用升级合约函数
        require(msg.sender != admin);
        (bool success, bytes memory data) = implementation.delegatecall(msg.data);
    }

    //升级合约：将逻辑合约地址指向新的合约地址
    //不安全：如果逻辑合约中有函数的selector与upgrade相同时，调用upgrade
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
