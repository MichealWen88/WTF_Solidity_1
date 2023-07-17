// SPDX-License-Identifier: MIT

pragma solidity >=0.8.19;


// ABI (Application Binary Interface，应用二进制接口)是与以太坊智能合约交互的标准。数据基于他们的类型编码；并且由于编码后不包含类型信息，解码时需要注明它们的类型。

// Solidity中，ABI编码有4个函数：
// abi.encode, 
// abi.encodePacked, 
// abi.encodeWithSignature, 
// abi.encodeWithSelector。
// 而ABI解码有1个函数：abi.decode，用于解码abi.encode的数据。这一讲，我们将学习如何使用这些函数。

contract ABI{
     uint x = 10;
    address addr = 0x7A58c0Be72BE218B41C608b7Fe7C5bB630736C71;
    string name = "0xAA";
    uint[2] array = [5, 6]; 

//ABI被设计出来跟智能合约交互，将每个参数填充为32字节的数据，并拼接在一起。
    function encode() public view returns(bytes memory result) {
        result = abi.encode(x, addr, name, array);
    }
// 它类似 abi.encode，但是会把其中填充的很多0省略。比如，只用1字节来编码uint类型。当你想省空间，并且不与合约交互的时候，可以使用abi.encodePacked
    function encodePacked() public view returns(bytes memory result) {
        result = abi.encodePacked(x, addr, name, array);
    }
    // 与abi.encode功能类似，只不过第一个参数为函数签名，比如"foo(uint256,address)"。当调用其他合约的时候可以使用。
    function encodeWithSignature() public view returns(bytes memory result) {
        result = abi.encodeWithSignature("foo(uint256,address,string,uint256[2])", x, addr, name, array);
    }


    // 与abi.encodeWithSignature功能类似，只不过第一个参数为函数选择器，为函数签名Keccak哈希的前4个字节。
    function encodeWithSelector() public view returns(bytes memory result) {
        result = abi.encodeWithSelector(bytes4(keccak256("foo(uint256,address,string,uint256[2])")), x, addr, name, array);
    }

// 我们将abi.encode的二进制编码输入给decode，将解码出原来的参数：
     function decode(bytes memory data) public pure returns(uint dx, address daddr, string memory dname, uint[2] memory darray) {
        (dx, daddr, dname, darray) = abi.decode(data, (uint, address, string, uint[2]));
    }




}