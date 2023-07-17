// SPDX-License-Identifier: MIT

pragma solidity >=0.8.19;

// delegatecall与call类似，是solidity中地址类型的低级成员函数。delegate中是委托/代表的意思，那么delegatecall委托了什么？

// 当用户A通过合约B来call合约C的时候，执行的是合约C的函数，语境(Context，可以理解为包含变量和状态的环境)也是合约C的：msg.sender是B的地址，并且如果函数改变一些状态变量，产生的效果会作用于合约C的变量上。
// 而当用户A通过合约B来delegatecall合约C的时候，执行的是合约C的函数，但是语境仍是合约B的：msg.sender是A的地址，并且如果函数改变一些状态变量，产生的效果会作用于合约B的变量上。

// 目前delegatecall主要有两个应用场景：
// 代理合约（Proxy Contract）：将智能合约的存储合约和逻辑合约分开：代理合约（Proxy Contract）存储所有相关的变量，并且保存逻辑合约的地址；所有函数存在逻辑合约（Logic Contract）里，通过delegatecall执行。当升级时，只需要将代理合约指向新的逻辑合约即可。
// 
// EIP-2535 Diamonds（钻石）：钻石是一个支持构建可在生产中扩展的模块化智能合约系统的标准。钻石是具有多个实施合约的代理合约。 更多信息请查看：钻石标准简介。

// 注意：delegatecall有安全隐患，使用时要保证当前合约和目标合约的状态变量存储结构相同，并且目标合约安全，不然会造成资产损失。

// solidity中的另一个低级函数delegatecall。与call类似，它可以用来调用其他合约；不同点在于运行的语境，B call C，语境为C，改变c的变量；而B delegatecall C，语境为B，改变B的变量。目前delegatecall最大的应用是代理合约和EIP-2535 Diamonds（钻石）。

contract C {
    event Log(address sender,uint num);
    uint public num;
    address public sender;
    function setVars(uint _num) public payable {
        num = _num;
        sender = msg.sender;
        emit Log( sender,num);
    }
}

contract B {
    // uint public num; //必须与c合约保持相同的状态变量
    address public sender;

        event Response(bool success, bytes data);


      // 通过call来调用C的setVars()函数，将改变合约C里的状态变量
    function callSetVars(address _addr, uint _num) external payable{
        // call setVars()
        (bool success, bytes memory data) = _addr.call(
            abi.encodeWithSignature("setVars(uint256)", _num)
        );
        emit Response(success,data);
    }

    // 通过delegatecall来调用C的setVars()函数，将改变合约B里的状态变量
    function delegatecallSetVars(address _addr, uint _num) external payable{
        // delegatecall setVars()
        (bool success, bytes memory data) = _addr.delegatecall(
            abi.encodeWithSignature("setVars(uint256)", _num)
        );
         emit Response(success,data);
    }
}