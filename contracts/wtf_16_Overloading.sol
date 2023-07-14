// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.8.19;


//solidity中允许函数进行重载（overloading），即名字相同但输入参数类型不同的函数可以同时存在，他们被视为不同的函数。注意，solidity不允许修饰器（modifier）重载。

contract Overloading{

    function saySomething() public pure returns(string memory){
        return "Nothing";
    }

    function saySomething(string memory _msg)public pure returns (string memory){
        // f(8);//报错，8可以是uint8或uint256，需要强制转换
        f(uint(8));

        return _msg;
    }

    function f(uint8 a)public pure returns (uint8){
        return a;
    }

    function f(uint256 a )public pure returns(uint256){
        return a;
    }
}