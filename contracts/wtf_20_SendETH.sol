// SPDX-License-Identifier: MIT

pragma solidity >=0.8.19;

// Solidity有三种方法向其他合约发送ETH，他们是：transfer()，send()和call()，其中call()是被鼓励的用法。
// 次优选择 transfer: gas limit 2300， 失败会自动revert
// 几乎没人用 send:  gas limit 2300，失败不会自动revert，需要自己处理
// 最优选择 call: 无gas limit，可以实现更复杂的逻辑，失败不会自动revert
contract ReceiveETH{

    event Log(uint256 amount ,uint gas);

    receive() external  payable {
        emit Log(msg.value,gasleft());
    }

    function getBalance() public view returns (uint){
        return  address(this).balance;
    }

}

contract SendETH{

    //payable表示部署合约的时候可以转eth进去
    constructor()payable {

    }

    receive()external  payable {

    }

// transfer
// 用法是接收方地址.transfer(发送ETH数额)。
// transfer()的gas限制是2300，足够用于转账，但对方合约的fallback()或receive()函数不能实现太复杂的逻辑。
// transfer()如果转账失败，会自动revert（回滚交易）。
    function transferETH(address payable to, uint256 amount) external payable {
        to.transfer(amount);
    }
// 用法是接收方地址.send(发送ETH数额)。
// send()的gas限制是2300，足够用于转账，但对方合约的fallback()或receive()函数不能实现太复杂的逻辑。
// send()如果转账失败，不会revert。
// send()的返回值是bool，代表着转账成功或失败，需要额外代码处理一下。
    function sendETH(address payable to ,uint256 amount) external  payable {
        bool succeed = to.send(amount);
        
        if (!succeed){
            // revert SendFailed(); 
        }
    }
// 用法是接收方地址.call{value: 发送ETH数额}("")。
// call()没有gas限制，可以支持对方合约fallback()或receive()函数实现复杂逻辑。
// call()如果转账失败，不会revert。
// call()的返回值是(bool, data)，其中bool代表着转账成功或失败，需要额外代码处理一下。
    function callETH(address payable  to ,uint256 amount)external payable   {
        (bool success,) = to.call{value:amount}("");
        if (!success){
       // revert CallFailed();
        }
    }

    function getBalance() public view returns (uint){
        return  address(this).balance;
    }
}