// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.8.19;

//倒入本地文件
import "./wtf_1.sol";
//通过网址导入
import 'https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/utils/Address.sol';
// 通过npm的目录导入
import '@openzeppelin/contracts/access/Ownable.sol';
//通过全局符号导入特定的合约
import {Yeye} from './wtf_13_Inheritance.sol';


contract Import{
    using  Address for address;

     // 声明yeye变量
    Yeye yeye = new Yeye(55);

    // 测试是否能调用yeye的函数
    function test() external payable {
        yeye.hip();
    }
}

