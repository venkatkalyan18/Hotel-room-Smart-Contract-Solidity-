// SPDX-License-Identifier: GPL-3.0

pragma solidity ^0.8.0;

contract HotelRoom{

    enum Status{vacant, occupied}
    Status public status;

    struct Transactions{
        address occupent;
        uint amount;
        uint timeStamp;
    }
    Transactions[] t;

    event Occpuy(address _occupent, uint _amount);

    address payable public owner ;

     constructor(){
        owner = payable(msg.sender);
        status = Status.vacant;
    }

    modifier OnlyOwner(){
        require(owner == msg.sender,"You are not the owner!");
        _;
    }

    modifier isVacant(){
        require(status == Status.vacant,"Room is not vacant!");
        _;
    }

    modifier checkPrice(uint _amount){
        require(msg.value >= _amount,"Invalid amount!");
        _;
    }

   

    function Book() public payable isVacant checkPrice(2 ether){
    
       (bool sent,) =owner.call{value:msg.value}("");

       require(sent,"Someting went wrong!");

       t.push(Transactions(msg.sender, msg.value, block.timestamp));

       status = Status.occupied;

       emit Occpuy(msg.sender, msg.value);

    }

    function VacentRoom() public OnlyOwner {
        require(status == Status.occupied,"Room already vacant");
        status = Status.vacant;
    }

    function TransactionHistory() public OnlyOwner view returns(Transactions[] memory){
        return t;
    }

}