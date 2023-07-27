// SPDX-License-Identifier: MIT

pragma solidity >=0.8.19;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";


// WETH (Wrapped ETH)是ETH的带包装版本。
// 我们常见的WETH，WBTC，WBNB，都是带包装的原生代币。那么我们为什么要包装它们？
// 在2015年，ERC20标准出现，该代币标准旨在为以太坊上的代币制定一套标准化的规则，从而简化了新代币的发布，
// 并使区块链上的所有代币相互可比。不幸的是，以太币本身并不符合ERC20标准。
// WETH的开发是为了提高区块链之间的互操作性 ，并使ETH可用于去中心化应用程序（dApps）。
// 它就像是给原生代币穿了一件智能合约做的衣服：穿上衣服的时候，就变成了WETH，符合ERC20同质化代币标准，可以跨链，可以用于dApp；
// 脱下衣服，它可1:1兑换ETH。

contract WETH is ERC20{

    event Deposit(address indexed dst,uint wad);
    event Withdraw(address indexed src,uint wad);

    constructor()ERC20("WETH","WETH"){

    }

    fallback()external payable  {
        deposit();
    }

    receive()external payable {
        deposit();
    }

    //存款，ETH包装成WETH
    function deposit()public payable  {
        _mint(msg.sender,msg.value);
        emit Deposit(msg.sender,msg.value);
    }

    //取款，WETH还原成ETH
    function withdraw(uint amount)external {
        require(balanceOf(msg.sender) >= amount,"insufficient balance");
        //燃烧掉WETH
        _burn(msg.sender, amount);
        //退回eth
        payable(msg.sender).transfer(amount);
        emit Withdraw(msg.sender, amount);
    }


}