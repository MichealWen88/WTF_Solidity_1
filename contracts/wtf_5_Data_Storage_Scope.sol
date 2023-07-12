// SPDX-License-Identifier: MIT

pragma solidity >=0.8.2 <0.9.0;



//引用类型：Reference Type: Reference types differ from value types in that they do not store values directly on their own. Instead, reference types store the address/pointer of the data’s location and do not directly share the data. You can modify the underlying data with different variable names. Reference types array, struct and mapping, which take up a lot of storage space. We need to deal with the location of the data storage when using them.


// 数据存储位置 Data Location: 
//   storage: on chain, high gas,  The state variables are storage by default, which are stored on-chain
//   memory: memory, low gas, The parameters and temporary variables in the function generally use memory label, which is stored in memory and not on-chain.
//   calldata: memory, low gas,  Similar to memory, stored in memory, not on-chain. The difference from memory is that calldata variables cannot be modified, and is generally used for function parameters.

// 数据作用域 Data Scope:
// 状态变量 State Variable: State variables are variables whose data is stored on-chain and can be accessed by in-contract functions, but their gas consumption is high.State variables are declared inside the contract and outside the functions:
// 局部变量 Local Variable: Local variables are variables that are only valid during function execution; they are invalid after function exit. The data of local variables are stored in memory, not on-chain, and their gas consumption is low. Local variables are declared inside a function:
// 全局变量 Global Variable: Global variables are variables that work in the global scope and are reserved keywords for solidity. They can be used directly in functions without declaring them:
contract DataStorageAndScope{

    uint[] public a = [1,2,3];// state variable: array x


    function fCallData(uint256[] calldata x)public pure returns (uint256[] calldata ) {
        //The parameter is the calldata array, which cannot be modified.
        //编译时错误
        // _x[0] = 0; //This modification will report an error.
        return (x);
    }

    // When storage (a state variable of the contract) is assigned to the local storage (in a function), a reference will be created, and changing value of the new variable will affect the original one. 
    function fStorage()public  {
        //Declare a storage variable xStorage, pointing to x. Modifying xStorage will also affect x
        uint[] storage xStorage = a;
        xStorage[0] = 255;
    }

    // Assigning storage to memory creates independent copies, and changes to one will not affect the other; and vice versa.
    // Assigning memory to memory will create a reference, and changing the new variable will affect the original variable.
    // Otherwise, assigning a variable to storage will create independent copies, and modifying one will not affect the other.
    function fMemory()public view {
        uint[] memory xMemory = a;
        xMemory[0] = 255;
        // this.global();
    }
    

//常用的全局变量 Below are some commonly used global variables:
// blockhash(uint blockNumber): (bytes32) The hash of the given block - only applies to the 256 most recent block.
// block.coinbase : (address payable) The address of the current block miner
// block.gaslimit : (uint) The gaslimit of the current block
// block.number : (uint) Current block number
// block.timestamp : (uint) The timestamp of the current block, in seconds since the unix epoch
// gasleft() : (uint256) Remaining gas
// msg.data : (bytes calldata) Complete calldata
// msg.sender : (address payable) Message sender (current caller)
// msg.sig : (bytes4) first four bytes of the calldata (i.e. function identifier)
// msg.value : (bytes4) number of wei sent with the message
    function global() external view returns (address,uint,bytes memory){
        address sender = msg.sender;
        uint blockNumber = block.number;
        bytes memory data = msg.data;
        return (sender,blockNumber,data);
    }
}