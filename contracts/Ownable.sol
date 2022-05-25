pragma solidity ^0.7.0;

contract Ownable{
    address public owner;

    constructor(){
        owner = msg.sender;
    }

    modifier OnlyOwner(){
        require(msg.sender == owner, "Only Owner is allowed this function");
        _;
    }

    function isOwner() public view returns(bool){
        return (msg.sender == owner);
    }

}