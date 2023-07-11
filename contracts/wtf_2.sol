// SPDX-License-Identifier: MIT
pragma solidity >=0.8.2 <0.9.0;

contract HelloWeb3{
    // uint256 public _n1 = 2**2;
    // uint256 public _n2 = _n1 >> 10;
    // uint256 public _n3 = _n2++;
    address public _address = 0x7A58c0Be72BE218B41C608b7Fe7C5bB630736C71;
    address payable  public  _address1 = payable (_address);
    uint256 public balance = _address1.balance;


    // 字节数组bytes分两种，一种定长（byte, bytes8, bytes32），另一种不定长。定长的属于数值类型，不定长的是引用类型（之后讲）。 定长bytes可以存一些数据，消耗gas比较少。
    bytes32 public _byte32 = "MiniSolidity"; 
    bytes1 public _byte = _byte32[0]; 

    enum ActionSet{ Buy,Sell,List}

    ActionSet public _action = ActionSet.Sell;

    function enumToUint() external view returns(uint){
        return uint(_action);
    }

}