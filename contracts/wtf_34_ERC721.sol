// SPDX-License-Identifier: MIT

pragma solidity >=0.8.19;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";



contract Ape is ERC721{
     uint public maxSupply = 10000;

     constructor(string memory name,string memory symbol) ERC721(name,symbol){
        
     }

     function mintTo(address to,uint tokenId)external {
         require(tokenId>=0 && tokenId <= maxSupply,"tokenId out of range");
         _mint(to, tokenId);
     }

}
