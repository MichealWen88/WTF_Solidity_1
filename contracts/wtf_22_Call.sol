// SPDX-License-Identifier: MIT

pragma solidity >=0.8.19;


//call不是调用合约的推荐方法，因为不安全。但他能让我们在不知道源代码和ABI的情况下调用目标合约，很有用。

contract OtherContract{
    uint256 private _x = 0;
    event Log(uint256 amount ,uint gas);
    

    receive() external payable{}

 // 可以调整状态变量_x的函数，并且可以往合约转ETH (payable)
    function setX(uint256 x) external payable{
        _x = x;
        // 如果转入ETH，则释放Log事件
        if(msg.value > 0){
            emit Log(msg.value, gasleft());
        }
    }

    // 读取_x
    function getX() external view returns(uint x){
        x = _x;
    }
}

contract CallContract{
    // 定义Response事件，输出call返回的结果success和data
    event Response(bool success, bytes data);

    function callSetX(address payable _address,uint256 x)public payable {
       (bool success,bytes memory data ) =  _address.call{value:msg.value}(abi.encodeWithSignature("setX(uint256)", x));
       emit Response(success, data);
    }

    function callGetX(address payable  _address) public payable returns(uint256){
         // call getX()
    (bool success, bytes memory data) = _address.call(
        abi.encodeWithSignature("getX()")
    );

    emit Response(success, data); //释放事件
    return abi.decode(data, (uint256));
    }
}