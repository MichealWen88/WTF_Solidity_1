// SPDX-License-Identifier: MIT

pragma solidity >=0.8.19;

//error: error是solidity 0.8版本新加的内容，方便且高效（省gas）地向用户解释操作失败的原因。
//require: 很好用，唯一的缺点就是gas随着描述异常的字符串长度增加，比error命令要高。
//assert:

contract Exception{
   mapping (uint256=>address) _owners;

    error TransferNotOwner();

    function transferOwner1(uint256 tokenId, address newOwner) public {
        if(_owners[tokenId] != msg.sender){
            revert TransferNotOwner();
        }
        _owners[tokenId] = newOwner;
    }

    function transferOwner2(uint256 tokenId, address newOwner) public {
        require(msg.sender == _owners[tokenId],"not owner");
        _owners[tokenId] = newOwner;
    }

    function transferOwner3(uint256 tokenId, address newOwner) public {
        assert(msg.sender == _owners[tokenId]);
        _owners[tokenId] = newOwner;
    }


}