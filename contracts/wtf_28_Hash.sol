// SPDX-License-Identifier: MIT

pragma solidity >=0.8.19;

// Hash的性质
// 一个好的哈希函数应该具有以下几个特性：

// 单向性：从输入的消息到它的哈希的正向运算简单且唯一确定，而反过来非常难，只能靠暴力枚举。
// 灵敏性：输入的消息改变一点对它的哈希改变很大。
// 高效性：从输入的消息到哈希的运算高效。
// 均一性：每个哈希值被取到的概率应该基本相等。
// 抗碰撞性：
// 弱抗碰撞性：给定一个消息x，找到另一个消息x'使得hash(x) = hash(x')是困难的。
// 强抗碰撞性：找到任意x和x'，使得hash(x) = hash(x')是困难的。

// Hash的应用
// 生成数据唯一标识
// 加密签名
// 安全加密

contract Hash{

    bytes32 _msg =  keccak256(abi.encode("0xAA"));

    //生成数据唯一标识

    function hash(
        uint _num,
        string memory _string,
        address _addr
    ) public pure returns (bytes32) {
        return keccak256(abi.encodePacked(_num, _string, _addr));
    }

   // 弱抗碰撞性
    function weak(
        string memory string1
    )public view returns (bool){
        return keccak256(abi.encodePacked(string1)) == _msg;
    }
     // 强抗碰撞性
    function strong(
        string memory string1,
        string memory string2
    )public pure returns (bool){
        return keccak256(abi.encodePacked(string1)) == keccak256(abi.encodePacked(string2));
    }
}