// SPDX-License-Identifier: MIT

pragma solidity >=0.8.19;

import "@openzeppelin/contracts/interfaces/IERC20.sol";


//代币锁合约：锁定token一段时间，到时间后释放给受益人，常用于锁定lp代币

//TokenLocker可以为任意address锁仓任意token
contract TokenLocker {

    event TokenLockStart(address indexed beneficiary, address indexed token,uint256 startTime,uint256 lockTime);
    event TokenReleased(address indexed  beneficiary,address indexed token, uint256 releaseTime,uint256 amount);
    
    struct TokenLock{
        uint256 lockTime;  //锁仓时间，单位为秒
        uint256 startTime; //锁仓开始时间
        uint256 amount; 
    }

    mapping  (address=> mapping (address => TokenLock)) public tokenLocks; //当前锁仓中的代币
    
    //锁仓代币
    function lock(address token, address beneficiary, uint256 lockTime,uint256 amount)external {
        require(lockTime > 0,"TokenLocker: lock time should be greater than 0");
        IERC20 _token = IERC20(token);
        //授权额度足够
        require(_token.allowance(msg.sender, address(this)) >= amount,"TokenLocker: need to approve more");
        //余额足够
        require(_token.balanceOf(msg.sender) >= amount,"TokenLocker: insufficient balance ");
        //代币锁已存在
        require(tokenLocks[beneficiary][token].amount == 0 ,"TokenLocker: token lock exsisted ");
        
        //代币转到合约
        _token.transferFrom(msg.sender, address(this), amount);
        tokenLocks[beneficiary][token] = TokenLock({ 
            amount:amount, startTime:block.timestamp,lockTime:lockTime
        });
        emit TokenLockStart(beneficiary, token, block.timestamp, lockTime);
    }

    //提取代币
    function release(address token) public{
        TokenLock memory _lock = tokenLocks[msg.sender][token];
        require(_lock.amount > 0 && (block.timestamp >= _lock.startTime+_lock.lockTime), "Token Locker: no available token");
        IERC20 _token = IERC20(token);
        //余额足够
        require(_token.balanceOf(address(this)) >= _lock.amount,"TokenLocker: insufficient balance0");
        _token.transfer(msg.sender, _lock.amount);
        delete tokenLocks[msg.sender][token];
        emit TokenReleased(msg.sender, token, block.timestamp, _lock.amount);
    }

}