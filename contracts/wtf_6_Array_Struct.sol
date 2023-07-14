// SPDX-License-Identifier: MIT

pragma solidity >=0.8.19;




contract ArrayStruct {

struct Student{
   uint256 id;
   uint256 score;
}


// Method 1: Create a storage struct reference in the function
function initStudent1()external {
    Student storage s =  student; // assign a copy of student
    s.id = 10;
    s.score = 99;
}

// Method 2: Directly refer to the struct of the state variable
function initStudent2()external {
      student.id = 1;
        student.score = 80;
}

// Method 3: 构造函数
function initStudent3()external {
    student = Student(3,100);
}
// Method 4: key value
function initStudent4()external {
    student = Student({id:5,score:100});
}

   Student student; // Initially a student structure

    // fixed-length array
    uint[8] array1;
    // byte[5] array2;
    address[100] array3;

    // variable-length array
    uint[] public array4;
    bytes array5;
    address[] array6;
    bytes array7;


    function arrayPush() public  {
        uint[2] memory x = [uint(1),2];
        array4 = x;
        array4.push(3);
        array4.push();
        array4.push(4);
    }

    function arrayPop()public{
        array4.pop();
    }


     
}