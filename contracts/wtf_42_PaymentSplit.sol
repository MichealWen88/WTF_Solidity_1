// SPDX-License-Identifier: MIT

pragma solidity >=0.8.19;

//收益分账
contract PaymentSplit {
    event PayeeAdded(address account,uint256 shares);
    event PaymentReleased(address to,uint256 amount);
    event PaymentReceived(address from, uint256 amount);

    uint256 public totalShares;   //总份额
    uint256 public totalReleased; //已分账金额
    mapping(address=>uint256) public shares; //受益人的份额;
    mapping (address=>uint256) public released; //已分账的金额;

    address[] public payees; //受益人数组

    constructor(address[] memory _payees,uint256[] memory _shares)payable {
        require(_payees.length == _shares.length);
        require(_payees.length>0);
        for (uint i = 0; i<_payees.length;i++){
            _addPayee(_payees[i], _shares[i]);
        }
    }
    receive()external virtual   payable {
        emit PaymentReceived(msg.sender, msg.value);
    }
    fallback()external payable {
        emit PaymentReceived(msg.sender, msg.value);
    }

    //计算受益人可分账金额
    function releaseable(address _account)public view returns(uint256) {
        //合约总收入
        uint256 totalReceived = address(this).balance + totalReleased;
        return pendingPayment(_account, totalReceived, released[_account]);
    }

    //计算受益人当前可提取金额
    function pendingPayment(
        address _account,
        uint256 _totalRecieved,
        uint256 _accountReleased)private view returns(uint256){

            return (_totalRecieved * shares[_account])/totalShares - _accountReleased;
        } 

    //释放奖金
    function release(address payable _account)public virtual {
        require(shares[_account]>0,"account has no shares");
        uint256 payment = releaseable(_account);
        require(payment!=0,"PaymentSplitter: account is not due payment");
        totalReleased += payment;
        released[_account] += payment;
        _account.transfer(payment);
        emit PaymentReleased(_account, payment);
    }

    //受益人提取资金
    function claim()public{
        release(payable(msg.sender));
    }


    //添加受益人，只能在构造函数中调用
    function _addPayee(address _account,uint256 _shares)private{
        require(_account != address(0),"payment for zero address");
        require(_shares >0 ,"zero shares");
        require(shares[_account] ==0 ," shares exists");
        payees.push(_account);
        shares[_account] = _shares;
        totalShares += _shares;
        emit PayeeAdded(_account, _shares);
    }
}