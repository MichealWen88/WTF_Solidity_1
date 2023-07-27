// SPDX-License-Identifier: MIT

pragma solidity >=0.8.19;

import "@openzeppelin/contracts/token/ERC1155/ERC1155.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol";


// https://eips.ethereum.org/EIPS/eip-1155
// erc721: 一个id只能有一个token，非同质化代币
// erc1155：一个id可以有多个token，同质化代币，适用于游戏中的装备等
//          每个id对应的metadata uri不一样
//参考LifeForm Item的实现：https://bscscan.com/address/0x2dfeb752222cccecb9bc0a934b02c3a86f633900#code
contract BAYC1155 is ERC1155{

    constructor()ERC1155("ipfs://test/"){

    }

    function mint(uint256 id,uint256 amount)external {
        _mint(msg.sender, id, amount, "");
    }

}