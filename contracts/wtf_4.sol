// SPDX-License-Identifier: MIT

pragma solidity >=0.8.2 <0.9.0;


contract FunctionOutput{
    // return multiple variables
    function returnMultiple()public pure returns (uint256 ,bool ,uint256[3] memory){
        return (1,true,[uint256(1),2,255]);
    }

    // return named variables
    function returnNamed()public pure returns (uint256 _number,bool _bool,uint256[3] memory _array){
        _number = 1;
        _bool = true;
        _array = [uint256(1),2,255];
    }

    // Named return, still support return
    function returnNamed2() public pure returns(uint256 _number, bool _bool, uint256[3] memory _array){
        return(1, true, [uint256(1),2,5]);
    }

    function readReturn()public pure {
        uint256 a;
        bool b;
        uint256[3] memory c;
        (a,b,c) = returnMultiple();
        (, b, ) = returnNamed();
    }
}