// SPDX-License-Identifier: MIT

pragma solidity >=0.8.19;


// 时间锁（Timelock）是银行金库和其他高安全性容器中常见的锁定机制。它是一种计时器，旨在防止保险箱或保险库在预设时间之前被打开，即便开锁的人知道正确密码。

// 在区块链，时间锁被DeFi和DAO大量采用。它是一段代码，他可以将智能合约的某些功能锁定一段时间。
// 它可以大大改善智能合约的安全性，举个例子，假如一个黑客黑了Uniswap的多签，准备提走金库的钱，但金库合约加了2天锁定期的时间锁，那么黑客从创建提钱的交易，到实际把钱提走，需要2天的等待期。
// 在这一段时间，项目方可以找应对办法，投资者可以提前抛售代币减少损失。

// 在创建Timelock合约时，项目方可以设定锁定期，并把合约的管理员设为自己。
// 时间锁主要有三个功能：

// 创建交易，并加入到时间锁队列。
// 在交易的锁定期满后，执行交易。
// 后悔了，取消时间锁队列中的某些交易。
// 项目方一般会把时间锁合约设为重要合约的管理员，例如金库合约，再通过时间锁操作他们。

// 时间锁合约的管理员一般为项目的多签钱包，保证去中心化。

contract Timelock{

    modifier onlyOwner(){
        require(msg.sender == admin,"Timelock: fobbiden");
        _;
    }

    modifier onlyTimelock(){
        require(msg.sender == address(this),"Timelock: fobbiden");
        _;
    }

    //交易创建并加入队列
    event QueueTransaction(bytes32 indexed txHash, address indexed target,uint value,string signature,bytes data, uint executeTime);

    //执行交易
    event ExecuteTransaction(bytes32 indexed txHash, address indexed target,uint value,string signature,bytes data, uint executeTime);

    //取消交易
    event CancelTransaction(bytes32 indexed txHash, address indexed target,uint value,string signature,bytes data, uint executeTime);

    //修改管理员
    event NewAdmin(address indexed newAdmin);

    address public admin; //管理员
    uint public constant GRACE_PERIOD = 7 days; //交易有效期，过期的交易作废
    uint public delay; //交易锁定时间
    mapping (bytes32 => bool) public queuedTx; //tx队列

    constructor(uint _delay){
        delay = _delay;
        admin = msg.sender;
    }

    function changeAdmin(address newAdmin)public  onlyTimelock{
        admin = newAdmin;
        emit NewAdmin(newAdmin);
    }

    function queueTransaction(address target, uint256 value, string memory signature, bytes memory data, uint executeTime)public onlyOwner returns(bytes32){
        require(executeTime >= block.timestamp + delay , "Timelock: invalid executeTime");
        bytes32 txHash = getTxHash(target,value,signature,data,executeTime);
        queuedTx[txHash] = true;
        emit QueueTransaction(txHash, target, value, signature, data, executeTime);
        return txHash;
    }

    function cancelTransaction(address target, uint256 value, string memory signature, bytes memory data, uint executeTime)public onlyOwner {
        bytes32 txHash = getTxHash(target,value,signature,data,executeTime);
        require(queuedTx[txHash],"Timelock: no tx queued");
        delete queuedTx[txHash];

        emit CancelTransaction(txHash, target, value, signature, data, executeTime);
    }

    function executeTransaction(address target, uint256 value, string memory signature, bytes memory data, uint256 executeTime) public payable onlyOwner returns (bytes memory) {
        bytes32 txHash = getTxHash(target, value, signature, data, executeTime);
        // 检查：交易是否在时间锁队列中
        require(queuedTx[txHash], "Timelock::executeTransaction: Transaction hasn't been queued.");
        // 检查：达到交易的执行时间
        require(block.timestamp >= executeTime, "Timelock::executeTransaction: Transaction hasn't surpassed time lock.");
        // 检查：交易没过期
       require(block.timestamp <= executeTime + GRACE_PERIOD, "Timelock::executeTransaction: Transaction is stale.");
        // 将交易移出队列
        queuedTx[txHash] = false;

        // 获取call data
        bytes memory callData;
        if (bytes(signature).length == 0) {
            callData = data;
        } else {
            callData = abi.encodePacked(bytes4(keccak256(bytes(signature))), data);
        }
        // 利用call执行交易
        (bool success, bytes memory returnData) = target.call{value: value}(callData);
        require(success, "Timelock::executeTransaction: Transaction execution reverted.");

        emit ExecuteTransaction(txHash, target, value, signature, data, executeTime);

        return returnData;
    }

    function getTxHash(address target, uint256 value, string memory signature, bytes memory data, uint executeTime) public pure returns(bytes32){
         return keccak256(abi.encode(target, value, signature, data, executeTime));
    }




}