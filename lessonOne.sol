// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;

contract LessonOne {
    // This is 'State'. Think of it as a variable stored on a global HDD.
    // 'public' automatically creates a "getter" function 
    uint256 public count; 
    address public owner;
    address public addresstemp; 

    // Someone has to pay 'Gas' (CPU/Disk tax) to run this.
    bool public isPaused;
    //Use modifiers instead of require statements in the functions.
    modifier onlyOwner(){
        require(msg.sender==owner,"Must be owner");
        _;
    }
    modifier errorcount(){
        require(count > 0,"Count is zero!");
        _;
    } 
    //   address=>balance.
    mapping ( address => uint256) public points;

    //runs only once,when the contract is deployed,to set the initial owner.
    constructor() {
        owner = msg.sender;
    }
    //users  can get 10 points.
    function claimPoints() public {
        points[msg.sender]=points[msg.sender]+10;
    }
    // Query points for a specific user.'view' is like 'const' in C++. It promises NOT to modify state. These calls are FREE.
    function getPoints(address user) public view returns (uint256) {
        return points[user];
    }
    // Transfer points to another address
    function transferPoints(address _toadd,uint256 _points) public {
        require(points[msg.sender]>=_points,"Not enough points");
        points[msg.sender]=points[msg.sender]-_points;
        points[_toadd]=points[_toadd]+_points;
    }
    //cheange status,use modifier
    function togglePause(bool state) public onlyOwner{
        isPaused=state;
    }
    // Increment the counter. Only the owner can call this.
    function increment() public onlyOwner{
        //require(msg.sender==owner,"caller is not the owner");
        require(isPaused==false,"Contract is paused");
        count += 1;
    }
    // Decrement the counter. 
    function decrement() public errorcount onlyOwner{
        // This is a "Pre-condition" check.If it fails, the transaction reverts with the message.
        //require(count > 0, "Underflow Alert: Count is already zero");
        count -= 1;
    }
    //change the initial owner.
    function changeOwner(address newOwner) public onlyOwner{
        //require(msg.sender==owner,"You are not the owner!");
        owner=newOwner;
    }
    function getCount() public onlyOwner view returns (uint256) {
        return count;
    }
}