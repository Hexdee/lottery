//SPDX-License-Identifier: MIT 

pragma solidity ^0.8.0;

contract Lottery{
    //owner is in charge of the contract 
    address public owner;
    //new player in the contract using array[] to unlimit number 
    address[] public players;
    //amount each user must send to buy ticket
    uint256 public ticketPrice;

    constructor(uint256 _ticketPrice) {
        owner = msg.sender;
        ticketPrice = _ticketPrice;
    }

    //to call the enter function we add them to players
    function buyTicket() public payable{
        //each player is compelled to add a certain ETH to join
        require(msg.value >= ticketPrice, "Please attach ticket price");
        players.push(msg.sender);
    }
    //Generate a random number that will be used to choose our winner
    function _random() private view returns(uint){
        return  uint256 (keccak256(abi.encode(block.timestamp,  players)));
    }

    function pickWinner() public onlyOwner{
        //only the owner can pickWinner
        //creates index that is gotten from func random % play.len
        uint winner = _random() % players.length;
        //pays the winner
        payable (players[winner]).transfer(address(this).balance);
        //empies the old lottery and starts new one
        players = new address[](0);
    }

    modifier onlyOwner(){
        require(msg.sender == owner);
        _;

    }
}
