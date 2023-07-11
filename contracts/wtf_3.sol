// SPDX-License-Identifier: MIT

pragma solidity >=0.8.2 <0.9.0;


// function语法
// function 函数名              参数列表              函数可见性                          函数权限              返回值列表
// function <function name> (<parameter types>) {internal|external|public|private} [pure|view|payable] [returns (<return types>)]

// 可见性：
// public: 内部外部均可见。(也可用于修饰状态变量，public变量会自动生成 getter函数，用于查询数值)
// private: 只能从本合约内部访问，继承的合约也不能用（也可用于修饰状态变量）
// external: 只能从合约外部访问（但是可以用this.f()来调用，f是函数名）
// internal: 只能从合约内部访问，继承的合约可以用（也可用于修饰状态变量），默认internal

// 权限：pure不可读写存储在链上的状态，view可读不可写 payable可转账 默认为可读可写

// 到底什么是Pure和View？
// 我刚开始学solidity的时候，一直不理解pure跟view关键字，因为别的语言没有类似的关键字。solidity加入这两个关键字，我认为是因为gas fee。
// 合约的状态变量存储在链上，gas fee很贵，如果不改变链上状态，就不用付gas。包含pure跟view关键字的函数是不改写链上状态的，因此用户直接调用他们是不需要付gas的（合约中非pure/view函数调用它们则会改写链上状态，需要付gas）。


// 在以太坊中，以下语句被视为修改链上状态：
// 写入状态变量。
// 释放事件。
// 创建其他合约。
// 使用selfdestruct.
// 通过调用发送以太币。
// 调用任何未标记view或pure的函数。
// 使用低级调用（low-level calls）。
// 使用包含某些操作码的内联汇编。

contract wtf3{

    uint256 public  i = 0;
    uint256 public _balance = address(this).balance;

    //add 函数不可以标记为pure 或 view
    function add() external  {
        i=i+1;
        i--;
        i++;
    }
    //pure函数：不可读写
    function add_pure(uint number) external pure returns (uint new_number){
        new_number = number+1;
    }

    // view函数：可读不可写
    function  add_view() public view returns (uint){
        return i+1;
    }

    // internal函数，只能内部访问
    function minus() internal {
        //如果i是0，-操作会报错，调用不成功，会revert
        if (i!=0) {
           i=i-1;
        }
    }

    // external函数，
    function minusCall() external {
        // 合约内的函数可以调用内部函数
        minus();
    }
    // payable函数，可以向合约转账
    function minusPayable() external  payable returns(uint256 balance) {
        minus();
        return address(this).balance;
    }

    function sum(uint x, uint y)external pure  returns(uint _sum){
        _sum = x+y;
    }
}