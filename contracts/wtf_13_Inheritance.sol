// SPDX-License-Identifier: MIT

pragma solidity >=0.8.19;

// override：重写

// virtual: 父合约中的函数，如果希望子合约重写，需要加上virtual关键字。

// override：子合约重写了父合约中的函数，需要加上override关键字。

//contract 和 modifier 都可以被override （重写）

contract Yeye {

    uint public immutable age;


    constructor(uint _age){
        age = _age;
    }

    event Log(string msg);

    function hip()public  virtual {
        emit Log("Yeye");
    }

    function hop()public  virtual {
        emit Log("Yeye");
    }
    function yeye()public  virtual {
        emit Log("Yeye");
    }


}


contract Baba is Yeye{

    //父合约的构造函数调用
    constructor() Yeye(51){
       
    }

    function hip()public  virtual override  {
        //调用父合约的function
        Yeye.hip();
        super.hip();
        emit Log("Baba");
    }

    function hop()public  virtual override  {
        emit Log("Baba");
    }
    function baba()public  virtual {
        emit Log("Baba");
    }
}

//多重继承
contract Erzi is Yeye,Baba{
    function hip()public   override (Yeye,Baba)  {
        Baba.hip();
        emit Log("Erzi");
    }

    function hop()public  override ( Yeye,Baba) {
         Baba.hop();
        emit Log("Erzi");
    }
    function erzi()public   {
        emit Log("Erzi");
    }
}