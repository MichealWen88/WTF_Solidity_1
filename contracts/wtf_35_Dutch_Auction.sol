// SPDX-License-Identifier: MIT

pragma solidity >=0.8.19;


import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/ERC721/ERC721.sol";


//荷兰拍
contract DutchAuction is Ownable, ERC721{

    //nft总数
    uint256 public constant COLLECTION_SIZE = 10000;
    //起拍价
    uint256 public constant AUCTION_START_PRICE = 1 ether;
    //底价
    uint256 public constant AUCTION_END_PRICE = 0.1 ether;
    //拍卖时长
    uint256 public constant AUCTION_TIME = 10 minutes;
    //价格衰减周期
    uint256 public constant AUCTION_DROP_INTERVAL = 1 minutes;
    //每次价格衰减步长
    uint256 public constant AUCTION_DROP_PER_STEP = (AUCTION_START_PRICE - AUCTION_END_PRICE)/(AUCTION_TIME/AUCTION_DROP_INTERVAL);

    uint256 public auctionStartTime;//拍卖开始时间戳
    string private _baseUri;
    uint256[] private _allTokens;

    constructor(string memory _name,string memory _symbol)ERC721(_name,_symbol){

    }

    function totalSupply()public view returns (uint256){
        return _allTokens.length;
    }

    function _addTokenToAllTokens(uint256 tokenId)private{
        _allTokens.push(tokenId);
    }
    //设置拍卖开始时间戳
    function setAuctionStartTime(uint32 timestamp) external onlyOwner{
        auctionStartTime = timestamp;
    }

    //获取当前拍卖实时价格
    function getCurrentPrice() public view returns (uint256){
        //拍卖未开始，返回拍卖开始价格        
        if (block.timestamp < auctionStartTime){
            return AUCTION_START_PRICE;
        //拍卖已结束，返回拍卖最低价
        }else if (block.timestamp - auctionStartTime >= AUCTION_TIME){
            return AUCTION_END_PRICE;
        }else{
            //拍卖进行中，计算并返回当前拍卖价格
            uint256 steps = (block.timestamp - auctionStartTime)/AUCTION_DROP_INTERVAL;
            return AUCTION_START_PRICE - (steps*AUCTION_DROP_PER_STEP);
        }
    }

    //参与拍卖mint
    function auctionMint(uint256 quantity) external  payable {
        uint256 _saleStartTime = uint256(auctionStartTime);// 建立local变量，节省gas
        require(_saleStartTime!=0 && block.timestamp >= _saleStartTime,"Sale not startted yet");
        require(totalSupply()+quantity <= COLLECTION_SIZE,"not enough reserved for quantity");
        uint256 totalCost = getCurrentPrice()* quantity;
        require(msg.value >= totalCost,"Need to send more ETH");
        for(uint256 i=0; i< quantity;i++){
            uint256 mintIndex = totalSupply();
            _mint(msg.sender, mintIndex);
            _addTokenToAllTokens(mintIndex);
        }
        //多余的ETH退款
        if (msg.value > totalCost){
            payable(msg.sender).transfer(msg.value-totalCost);
        }
    }

    function withdraw() external onlyOwner{
        (bool success,) = msg.sender.call{ value: address(this).balance}("");
        require(success,"withdraw failed.");
    }


}