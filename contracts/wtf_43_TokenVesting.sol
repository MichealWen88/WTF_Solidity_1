// SPDX-License-Identifier: MIT

pragma solidity >=0.8.19;

import "@openzeppelin/contracts/interfaces/IERC20.sol";

//代币释放合约

// 在传统金融领域，一些公司会向员工和管理层提供股权。但大量股权同时释放会在短期产生抛售压力，拖累股价。因此，公司通常会引入一个归属期来延迟承诺资产的所有权。同样的，在区块链领域，Web3初创公司会给团队分配代币，同时也会将代币低价出售给风投和私募。如果他们把这些低成本的代币同时提到交易所变现，币价将被砸穿，散户直接成为接盘侠。
// 所以，项目方一般会约定代币归属条款（token vesting），在归属期内逐步释放代币，减缓抛压，并防止团队和资本方过早躺平。


contract TokenVesting{
    event ERC20Released(address indexed to,uint256 amount);
    
    //代币地址=>已释放的数量
    mapping(address=>uint256) public erc20Released;

    //受益人
    address public immutable beneficiary;

    //开始时间戳
    uint256 public immutable start;
    //归属市场，单位为秒
    uint256 public immutable duration;

    constructor(address _beAddress,uint256 _duration){
        require(_beAddress != address(0),"TokenVesting: beneficiary is zero address");
        start = block.timestamp;
        duration = _duration;
        beneficiary = _beAddress;
    }

    function release(address token) public{
        uint256 releaseable = vestedAmount(token, uint256(block.timestamp));
        erc20Released[token] += releaseable;
        emit ERC20Released(beneficiary, releaseable);
        IERC20(token).transfer(beneficiary,releaseable);
    }

    //计算已经释放的代币数
    function vestedAmount(address token,uint256 timestamp) public view returns(uint256){
        uint256 totalAllocation = IERC20(token).balanceOf(address(this)) + erc20Released[token];
        if (timestamp<start){
            return 0;
        }else if (timestamp > start +duration){
            return totalAllocation;
        }else {
            return totalAllocation * (timestamp - start)/duration;
        }
    } 
    
}