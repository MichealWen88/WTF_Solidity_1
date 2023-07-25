// SPDX-License-Identifier: MIT

pragma solidity >=0.8.19;

import "@openzeppelin/contracts/token/ERC721/IERC721Receiver.sol";
import "@openzeppelin/contracts/token/ERC721/IERC721.sol";
import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@chainlink/contracts/src/v0.8/interfaces/VRFCoordinatorV2Interface.sol";
import "@chainlink/contracts/src/v0.8/VRFConsumerBaseV2.sol";

// 测试合约地址
// https://sepolia.etherscan.io/address/0x2fb8e626537541beae2144e349ee27a775a02f1e
contract RandomIdNFT is ERC721,VRFConsumerBaseV2{

    //请求随机数需要调用VRFCoordinatorV2Interface接口
    VRFCoordinatorV2Interface COORDINATOR;
    // 申请后的subId
    uint64 subId;
    //存放得到的 requestId 和 随机数
    uint256 public requestId;
    uint256[] public randomWords;

    /**
     * 使用chainlink VRF，构造函数需要继承 VRFConsumerBaseV2
     * 不同链参数填的不一样
     * 具体可以看：https://docs.chain.link/vrf/v2/subscription/supported-networks
     * 网络: Sepolia测试网
     * Chainlink VRF Coordinator 地址: 0x8103B0A8A00be2DDC778e6e7eaa21791Cd364625
     * LINK 代币地址: 0x01BE23585060835E02B77ef475b0Cc51aA1e0709
     * 30 gwei Key Hash: 0x474e34a077df58807dbe9c96d3c009b23b3c6d0cce433e59bbf5b34f823bc56c
     * Minimum Confirmations 最小确认块数 : 3 （数字大安全性高，一般填12）
     * callbackGasLimit gas限制 : 最大 2,500,000
     * Maximum Random Values 一次可以得到的随机数个数 : 最大 500          
     */
    address vrfCoordinator = 0x8103B0A8A00be2DDC778e6e7eaa21791Cd364625;
    bytes32 keyHash = 0x474e34a077df58807dbe9c96d3c009b23b3c6d0cce433e59bbf5b34f823bc56c;
    uint16 requestConfirmations = 3;
    uint32 callbackGasLimit = 200_000;
    uint32 numWords = 3;

    mapping (uint256=>address) public requestToSender;
    uint256 public totalSupply = 100;
    uint256[100] public ids;
    uint256 public mintCount; //已mint的数量

 
    constructor()
       VRFConsumerBaseV2(vrfCoordinator)
       ERC721("RandomIdNFT","RANDOM")
    {
        COORDINATOR = VRFCoordinatorV2Interface(vrfCoordinator);
        subId = 3903;
    }


    // 1.链上随机数，方便的做法，但不安全
    // 使用全局变量block.number，msg.sender和blockhash(block.timestamp-1)作为种子来获取随机数：
    // 不安全，block.number，msg.sender和blockhash(block.timestamp-1)这些变量都是公开的，使用者可以预测出用这些种子生成出的随机数，并挑出他们想要的随机数执行合约。
    // 矿工可以操纵blockhash和block.timestamp，使得生成的随机数符合他的利益。
    //由于这种方法是最便捷的链上随机数生成方法，大量项目方依靠它来生成不安全的随机数，包括知名的项目meebits，loots等。当然，这些项目也无一例外的被攻击了：攻击者可以铸造任何他们想要的稀有NFT，而非随机抽取。
    function getRandomOnchain() public view returns (uint256){
        bytes32 randomBytes = keccak256(abi.encodePacked(block.number,msg.sender,blockhash(block.timestamp-1)));
        return uint256(randomBytes);
    }

    //使用链上随机数mint
    function mintRandomOnchain()public{
        uint256 tokenId = pickRandomUniqueId(getRandomOnchain());
        _mint(msg.sender, tokenId);
    }

    //2.ChainLink VRF，链下生成随机数，然后通过预言机把随机数传到链上
    function mintRandomVRF()public{
        requestId = COORDINATOR.requestRandomWords(
            keyHash, subId, requestConfirmations, callbackGasLimit, numWords);
        requestToSender[requestId] = msg.sender;
    }

    //Chainlink VRF回调函数，Chainlink会把生成的随机数回调到这个函数里面
    function fulfillRandomWords(uint256 _requestId, uint256[] memory s_randomWords)internal override {
        address sender = requestToSender[_requestId];
        uint256 tokenId = pickRandomUniqueId(s_randomWords[0]);
        _mint(sender, tokenId);
    }

    // //Chainlink合约回调函数，在此函数内进行获取随机数，然后进行mint
    // function fulfillRandomness(bytes32 requestId, uint256 randomness) internal override{
    //     address addr = requestToSender[requestId];
    //     uint256 tokenId = pickRandomUniqueId(randomness);
    //     _mint(addr,tokenId);
    // }

        /** 
    * 输入uint256数字，返回一个可以mint的tokenId
    * 算法过程可理解为：totalSupply个空杯子（0初始化的ids）排成一排，每个杯子旁边放一个球，编号为[0, totalSupply - 1]。
    每次从场上随机拿走一个球（球可能在杯子旁边，这是初始状态；也可能是在杯子里，说明杯子旁边的球已经被拿走过，则此时新的球从末尾被放到了杯子里）
    再把末尾的一个球（依然是可能在杯子里也可能在杯子旁边）放进被拿走的球的杯子里，循环totalSupply次。相比传统的随机排列，省去了初始化ids[]的gas。
    */
    function pickRandomUniqueId(uint256 random) private returns (uint256 tokenId) {
        uint256 len = totalSupply - mintCount++; // 可mint数量
        require(len > 0, "mint close"); // 所有tokenId被mint完了
        uint256 randomIndex = random % len; // 获取链上随机数
        
        //随机数取模，得到tokenId，作为数组下标，同时记录value为len-1，如果取模得到的值已存在，则tokenId取该数组下标的value
        tokenId = ids[randomIndex] != 0 ? ids[randomIndex] : randomIndex; // 获取tokenId
        ids[randomIndex] = ids[len - 1] == 0 ? len - 1 : ids[len - 1]; // 更新ids 列表
        ids[len - 1] = 0; // 删除最后一个元素，能返还gas
    }

}