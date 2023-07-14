// SPDX-License-Identifier: MIT

pragma solidity >=0.8.19;


//abstract contract 至少有一个function未实现
abstract contract AbstractContract{
    function insertionSort(uint[] memory a) public pure virtual returns(uint[] memory);

}

contract Sort is AbstractContract{

    //子合约必须override父合约未实现的function
    function insertionSort(uint[] memory a) public pure override  virtual returns(uint[] memory){

    }

}

interface HelloWorld{
    //定义接口
    function hello(string memory _msg) external pure ;
}

contract HellowWeb3 is HelloWorld{

        //实现接口
        function hello(string memory _msg) external pure override {
            
        }
}