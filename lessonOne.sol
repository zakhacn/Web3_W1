// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;

contract LessonOne {
    // This is 'State'. Think of it as a variable stored on a global HDD.
    // 'public' automatically creates a "getter" function for you.
    uint256 public count; 
    address public owner;
    // This is a 'Transaction'. It changes the global state.
    // Someone has to pay 'Gas' (CPU/Disk tax) to run this.
    bool public isPaused;

    modifier onlyOwner(){
        require(msg.sender==owner,"Must be owner");
        _;
    }
    modifier errorcount(){
        require(count > 0,"Count is zero!");
        _;
    }    
    mapping ( address => uint256) public points;

    constructor() {
        owner = msg.sender;
    }

    function claimPoints() public {
        points[msg.sender]=points[msg.sender]+10;
    }

    function getPoints(address user) public view returns (uint256) {
        return points[user];
    }
    
    function transferPoints(address _toadd,uint256 _points) public {
        require(points[msg.sender]>=_points,"Not enough points");
        points[msg.sender]=points[msg.sender]-_points;
        points[_toadd]=points[_toadd]+_points;
    }
    
    function togglePause(bool state) public onlyOwner{
        isPaused=state;
    }

    function increment() public onlyOwner{
        //require(msg.sender==owner,"caller is not the owner");
        require(isPaused==false,"Contract is paused");
        count += 1;
    }
    function decrement() public errorcount onlyOwner{
         // This is a "Pre-condition" check. 
         // If it fails, the transaction reverts with the message.
        //require(count > 0, "Underflow Alert: Count is already zero");
    
        count -= 1;
    }
    function changeOwner(address newOwner) public onlyOwner{
        //require(msg.sender==owner,"You are not the owner!");
        owner=newOwner;
    }
    // 'view' is like 'const' in C++. 
    // It promises NOT to modify state. These calls are FREE.
    function getCount() public onlyOwner view returns (uint256) {
        return count;
    }
}