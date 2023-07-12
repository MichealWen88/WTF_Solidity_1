// SPDX-License-Identifier: MIT

pragma solidity >=0.8.2 <0.9.0;


contract Mapping{
    mapping(uint => address) public idToAddress;

    function writeMap(uint key,address addr)public {
        idToAddress[key] = addr;
    }
}