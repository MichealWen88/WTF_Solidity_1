// SPDX-License-Identifier: MIT

pragma solidity >=0.8.19;

import "@openzeppelin/contracts/token/ERC721/IERC721Receiver.sol";
import "@openzeppelin/contracts/token/ERC721/IERC721.sol";


contract NFTSwap is IERC721Receiver{
    //上架，上架后nft转到合约地址
    event List(address indexed seller, address indexed nftAddr, uint256 indexed tokenId, uint256 price);
    event Purchase(address indexed buyer, address indexed nftAddr, uint256 indexed tokenId, uint256 price);
    event Revoke(address indexed seller, address indexed nftAddr, uint256 indexed tokenId);    
    event Update(address indexed seller, address indexed nftAddr, uint256 indexed tokenId, uint256 newPrice);

 // 定义order结构体
    struct Order{
        address owner;
        uint256 price; 
    }
    // NFT Order映射
    mapping(address => mapping(uint256 => Order)) public nftList;

    fallback()external payable {

    }

    // 实现{IERC721Receiver}的onERC721Received，能够接收ERC721代币
    function onERC721Received(
        address operator,
        address from,
        uint tokenId,
        bytes calldata data
    ) external override returns (bytes4){
        return IERC721Receiver.onERC721Received.selector;
    }

    function list(address _nftAddress,uint256 _tokenId, uint256 _price)public{
        IERC721 _nft = IERC721(_nftAddress);
        require(_nft.getApproved(_tokenId) == address(this));
        require(_price>0);
        Order storage _order = nftList[_nftAddress][_tokenId];
        _order.owner = msg.sender;
        _order.price = _price;
        //nft转到合约地址
        _nft.safeTransferFrom(msg.sender, address(this), _tokenId);
        emit List(msg.sender, address(this), _tokenId, _price);
    }

    function revoke(address _nftAddress,uint256 _tokenId)public{
        Order storage _order = nftList[_nftAddress][_tokenId];
        require(_order.owner == msg.sender,"Not Owner");

        IERC721 _nft = IERC721(_nftAddress);
        require(_nft.ownerOf(_tokenId) == address(this), "Invalid Order"); // NFT在合约中

        _nft.safeTransferFrom(address(this), msg.sender, _tokenId);
        delete nftList[_nftAddress][_tokenId];

        emit Revoke(msg.sender,_nftAddress, _tokenId);
    }

    function update(address _nftAddress,uint256 _tokenId,uint256 _price)public{
        Order storage _order = nftList[_nftAddress][_tokenId];
        require(_order.owner == msg.sender,"Not Owner");
        require(_price>0);
        _order.price = _price;
        nftList[_nftAddress][_tokenId] = _order;
        emit Update(msg.sender, _nftAddress, _tokenId, _price);
    }

    function purchase(address _nftAddress,uint256 _tokenId)public payable {
        Order storage _order = nftList[_nftAddress][_tokenId];
        require(_order.price>0,"Invalid price");
        require(msg.value > _order.price,"Not enough eth");
        IERC721 _nft = IERC721(_nftAddress);
        require(_nft.ownerOf(_tokenId) == address(this), "Invalid Order"); 

        //nft发送给买家
        _nft.safeTransferFrom(address(this), msg.sender, _tokenId);
        //eth支付给卖家
        payable(_order.owner).transfer(_order.price);
        //多出的eth退回给卖家
        if (msg.value - _order.price>0){
           payable(msg.sender).transfer(msg.value - _order.price);
        }

        delete nftList[_nftAddress][_tokenId];

        emit Purchase(msg.sender, _nftAddress, _tokenId, _order.price);
    }


}