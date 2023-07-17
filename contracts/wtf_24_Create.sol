// SPDX-License-Identifier: MIT

pragma solidity >=0.8.19;

// 在以太坊链上，用户（外部账户，EOA）可以创建智能合约，智能合约同样也可以创建新的智能合约。
// 去中心化交易所uniswap就是利用工厂合约（Factory）创建了无数个币对合约（Pair）。这一讲，我会用简化版的uniswap讲如何通过合约创建合约。

// create的用法很简单，就是new一个合约，并传入新合约构造函数所需的参数：

// Contract x = new Contract{value: _value}(params)

// 其中Contract是要创建的合约名，x是合约对象（地址），如果构造函数是payable，可以创建时转入_value数量的ETH，params是新合约构造函数的参数。

// Uniswap V2核心合约中包含两个合约：

// UniswapV2Pair: 币对合约，用于管理币对地址、流动性、买卖。
// UniswapV2Factory: 工厂合约，用于创建新的币对，并管理币对地址。
// 下面我们用create方法实现一个极简版的Uniswap：Pair币对合约负责管理币对地址，PairFactory工厂合约用于创建新的币对，并管理币对地址。


contract Pair{
    address public factory;
    address public token0;
    address public token1;

    constructor()payable {
        factory = msg.sender;
    }

    //factory创建合约时调用一次
    function init(address _token0,address _token1) external {
        require(msg.sender == factory," UniSwapV2: FOBIDDEN");
        token0 = _token0;
        token1 = _token1;
    }

}

contract PairFactory{
    //
    mapping (address=>mapping (address=>address)) public getPair;
    address[] public  pairs;
    function createPair(address token0,address token1)external returns (address pairAddr){
        //创建合约
        Pair pair = new Pair();
        //初始化
        pair.init(token0,token1);
        //保存币对地址，方便根据token0 和token1的地址查找币对地址
        pairAddr = address(pair);
        pairs.push(pairAddr);
        getPair[token0][token1] = pairAddr;
        getPair[token1][token0] = pairAddr;
    }  
}