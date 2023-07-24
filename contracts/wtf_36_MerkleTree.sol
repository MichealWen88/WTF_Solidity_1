// SPDX-License-Identifier: MIT

pragma solidity >=0.8.19;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";



// Merkle Tree，也叫默克尔树或哈希树，是区块链的底层加密技术，被比特币和以太坊区块链广泛采用。Merkle Tree是一种自下而上构建的加密树，每个叶子是对应数据的哈希，而每个非叶子为它的2个子节点的哈希。

library MerkleProof {
    /**
     * @dev 当通过`proof`和`leaf`重建出的`root`与给定的`root`相等时，返回`true`，数据有效。
     * 在重建时，叶子节点对和元素对都是排序过的。
     */
    function verify(
        bytes32[] memory proof,
        bytes32 root,
        bytes32 leaf
    ) internal pure returns (bool) {
        return processProof(proof, leaf) == root;
    }

    /**
     * @dev Returns 通过Merkle树用`leaf`和`proof`计算出`root`. 当重建出的`root`和给定的`root`相同时，`proof`才是有效的。
     * 在重建时，叶子节点对和元素对都是排序过的。
     */
    function processProof(bytes32[] memory proof, bytes32 leaf) internal pure returns (bytes32) {
        bytes32 computedHash = leaf;
        for (uint256 i = 0; i < proof.length; i++) {
            computedHash = _hashPair(computedHash, proof[i]);
        }
        return computedHash;
    }

    // Sorted Pair Hash
    function _hashPair(bytes32 a, bytes32 b) private pure returns (bytes32) {
        return a < b ? keccak256(abi.encodePacked(a, b)) : keccak256(abi.encodePacked(b, a));
    }
}

contract WhiteList is ERC721{
    bytes32 immutable public root;
    mapping (address=>bool) public mintedAddress;


    //构造函数传入root proof
    constructor(bytes32 rootProof)ERC721("wtf","wtf"){
        root = rootProof;
    }

    //计算叶子结点的hash
    function _leaf(address addr) internal pure returns(bytes32){
        return keccak256(abi.encodePacked(addr));
    }

    //根据传入的proof和leaf的hash计算root proof,如果计算得出的root proof 与记录的root相同，则验证通过
    function _verify(bytes32 leaf,bytes32[] memory proof ) internal view returns (bool){
        return MerkleProof.verify(proof,root,leaf);
    }

    
    function mint(address addr,uint256 id, bytes32[] calldata proof) external  {
        require(_verify(_leaf(addr),proof),"invalid merkle proof");
        require(mintedAddress[addr]==false,"already minted");
        _mint(addr, id);
        mintedAddress[addr] = true;
    }

}