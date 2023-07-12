// SPDX-License-Identifier: MIT

pragma solidity >=0.8.2 <0.9.0;


contract ControlFlow{

    function ifElseTest(uint number) public pure returns(bool){
        if (number==0){
            return true;
        }else{
            return false;
        }
    }

    function forLoopTest() public pure returns(uint256) {
        uint256 sum;
        for(uint i=0;i<10;i++){
            sum += i;
        }
        return sum;
    }
    
}