// SPDX-License-Identifier: MIT

pragma solidity >=0.8.19;


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


    //插入排序  错误写法
    function insertionSortWrong(uint[] memory array)public  pure returns(uint[] memory ) {
        for (uint i=1;i < array.length;i++){
            uint temp = array[i];
            uint j = i-1;
            while ((j>=0) && (temp < array[j])){
                array[j+1] = array[j];
                j--;  //如果j=0，则会报错
            }
            array[j+1] = temp;
        }
        return (array);
    }

    //插入排序
    function insertionSort(uint[] memory array)public  pure returns(uint[] memory ) {
        for (uint i=1;i < array.length;i++){
            uint temp = array[i];
            uint j = i;
            while ((j>=1) && (temp < array[j-1])){
                array[j] = array[j-1];
                j--;
            }
            array[j] = temp;
        }
        return (array);
    }
    
}