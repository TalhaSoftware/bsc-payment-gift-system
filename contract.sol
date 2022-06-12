pragma solidity ^0.8.7;

import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/token/ERC20/IERC20.sol";



contract SystemGift{
    
    struct giftInfo{
    address sender_addr;
    address recipient_addr;
    string sender_name;
    string sender_message;
    uint sender_value;
    address tokentype;
    bool status;
        }

    mapping(uint => giftInfo) public registers;

    uint public usage_n = 0;

    function sendGift(address recipient,uint value,string memory message,string memory sendername,address tokendest) public payable{
        Gift memory nGift;
        nGift.sender_addr = msg.sender;
        nGift.recipient_addr = recipient;
        nGift.sender_name = sendername;
        nGift.sender_message = message;
        nGift.sender_value = value;
        nGift.tokentype = tokendest;
        nGift.status = true;
        registers[usage_n] = nGift;
        usage_n += 1;

        IERC20 _tokenContract = IERC20(tokendest);        
        
        _tokenContract.transferFrom(msg.sender, address(this), value);
    }

    function TakeGift(uint giftid) public payable{ 
        address recipient = registers[giftid].recipient_addr;
        require(recipient == msg.sender,"This gift is not for you.");
        require(registers[giftid].status == true,"You have already taken the gift.");
        uint sentamount = registers[giftid].sender_value;
        address token = registers[giftid].tokentype;
        IERC20(token).transfer(msg.sender, sentamount);

        registers[giftid].sender_value = 0;
        registers[giftid].status = false;
    }

    function showInfo(uint id) public view returns(Gift memory){
        return registers[id];
       
    }

    function getTotal() public view returns(uint)
    {   
        return usage_n;
    }


}