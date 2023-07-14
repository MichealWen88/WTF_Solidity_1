// SPDX-License-Identifier: MIT
pragma solidity >=0.8.19;


// Solidity中的事件（event）是EVM上日志的抽象，它具有两个特点：

// 响应：应用程序（ether.js）可以通过RPC接口订阅和监听这些事件，并在前端做响应。
// 经济：事件是EVM上比较经济的存储数据的方式，每个大概消耗2,000 gas；相比之下，链上存储一个新变量至少需要20,000 gas。

contract Event{
   // indexed: 索引键，在以太坊上单独作为一个topic进行存储和索引，程序可以轻松的筛选出特定转账地址和接收地址的转账事件
   // 每个event最多3个indexed键，每个 indexed 变量的大小为固定的256比特。
   // value 不带 indexed 关键字，会存储在事件的 data 部分中，可以理解为事件的“值”。data 部分的变量不能被直接检索，但可以存储任意大小的数据。
   // 因此一般 data 部分可以用来存储复杂的数据结构，例如数组和字符串等等，因为这些数据超过了256比特，即使存储在事件的 topic 部分中，也是以哈希的方式存储。另外，data 部分的变量在存储上消耗的gas相比于 topic 更少。
   event Transfer(address indexed from, address indexed to, uint256 value);

   function _transfer(address from,address to,uint256 amount) external {
        // 释放事件
        emit Transfer(from, to, amount);
   }

}