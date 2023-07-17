// SPDX-License-Identifier: MIT

pragma solidity >=0.8.19;

// 开发者写智能合约来调用其他合约，这让以太坊网络上的程序可以复用，从而建立繁荣的生态。
// 很多web3项目依赖于调用其他合约，比如收益农场（yield farming）。这一讲，我们介绍如何在已知合约代码（或接口）和地址情况下调用目标合约的函数。
contract OtherContract{
    uint256 private _x = 0;
    event Log(uint256 amount ,uint gas);

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

    //1.传入合约地址
    //我们可以在函数里传入目标合约地址，生成目标合约的引用，然后调用目标函数。
    function callSetX(address _address,uint256 x)external {
        OtherContract(_address).setX(x);
    }
    //2.传入合约变量
    //我们可以直接在函数里传入合约的引用，只需要把上面参数的address类型改为目标合约名，比如OtherContract。
    function callGetX(OtherContract _address) external view returns(uint256) {
        return _address.getX();
    }
    //3. 创建合约变量
    //我们可以创建合约变量，然后通过它来调用目标函数。
    function callGetX2(address _address)external  view returns(uint256){
        OtherContract other = OtherContract(_address);
        return other.getX();
    }

    //调用合约并完成ETH转账
    function setXTransfer(address other,uint256 x)external  payable {
        OtherContract(other).setX{value:msg.value}(x);
    }
}