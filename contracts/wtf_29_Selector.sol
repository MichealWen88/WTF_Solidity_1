// SPDX-License-Identifier: MIT

pragma solidity >=0.8.19;

// 当我们调用智能合约时，本质上是向目标合约发送了一段calldata
// 发送的calldata中前4个字节是selector（函数选择器）

// msg.data是solidity中的一个全局变量，值为完整的calldata（调用函数时传入的数据）。

// method id、selector和函数签名
// method id定义为函数签名的Keccak哈希后的前4个字节，当selector与method id相匹配时，即表示调用该函数，那么函数签名是什么？

// 其实在第21讲中，我们简单介绍了函数签名，为"函数名（逗号分隔的参数类型)"。举个例子，上面代码中mint的函数签名为"mint(address)"。在同一个智能合约中，不同的函数有不同的函数签名，因此我们可以通过函数签名来确定要调用哪个函数。

// 注意，在函数签名中，uint和int要写为uint256和int256。

contract Selector{

 // event 返回msg.data
    event Log(bytes data);

    function mint(address to) external{
        emit Log(msg.data);
    }

    function mintSelector() external pure returns(bytes4 mSelector){
        return bytes4(keccak256("mint(address)"));
    }

     function callWithSignature() external returns(bool, bytes memory){
        (bool success, bytes memory data) = address(this).call(abi.encodeWithSelector(0x6a627842, "0x2c44b726ADF1963cA47Af88B284C06f30380fC78"));
        return(success, data);
    }
    
}