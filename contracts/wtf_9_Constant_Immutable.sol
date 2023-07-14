// SPDX-License-Identifier: MIT

pragma solidity >=0.8.19;

contract ConstantImmutable{
    //constant在声明时就必须初始化且不可改变
    uint256 public constant a = 1;

    //immutable可以在构造函数内初始化，后续不可改变
    uint256 public immutable b = 2;
    uint256 public immutable b2;
    uint256 public immutable b4 = test(); //可以使用函数初始化
    uint256 public immutable b3 = block.number; //可以使用全局变量初始化
    

    constructor(){
        b2 = 3;
        // b2 = block.number; //编译报错
        // b4 = test(); //也可以使用函数初始化
    }

    function test() public pure returns(uint256){
        uint256 what = 9;
        return(what);
    }
}