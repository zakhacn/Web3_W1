// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;

contract lesson2advanced{

    address public owner;
    //A custom data type,just like c++
    struct Profile{
        string username;
        bool exists;
    }

    //event = log
    event TransferOccurred(address indexed from ,address indexed to,uint256 amount);
    event ApproveOccurred(address indexed owner,address indexed spender,uint256 amount);

    mapping (address=> Profile) profiles;
    mapping (address=>uint256) balance;
    //Nested Mapping
    mapping (address=>mapping (address=>uint256)) allowance;
    mapping (address=>uint256) lockTime;

    modifier onlyOwner(){
        require(msg.sender==owner,"Only the owner can do this!");
        _;
    }

    constructor(){
        owner=msg.sender;
    }
    //lesson2-1 add a profile
    function setProfile(string memory _name) public {
        require(profiles[msg.sender].exists==false,"This user already has a profile");
        profiles[msg.sender].username=_name;
        profiles[msg.sender].exists=true;
    }

    function getProfile() public view returns (string memory,bool){
        return (profiles[msg.sender].username,profiles[msg.sender].exists);
    }
    
    function increment() public {
        balance[msg.sender]+=500;
        lockTime[msg.sender]=block.timestamp+ 30 seconds;
    }
    //lesson2-2 used block.timestamp 
    function decrement() public {
        require(balance[msg.sender]>=500,"not enough balance");
        require(block.timestamp>=lockTime[msg.sender],"You have to wait 30 seconds to decrement");
        balance[msg.sender]-=500;
    }
    //lesson2-3 turned the contract into a "Bank" by accepting real Ether via payable and msg.value
    function buyPoints() public payable {
        require(msg.value>=7 gwei,"Not enough ETH sent");
        balance[msg.sender]+=50000;
    }
    //balance shows on the top of the Deployed Contracts Tab
    function getcontractbalance() public onlyOwner view returns(uint256) {
        return address(this).balance;
    }
    //lesson2-4 .call() , .transfer() and .send()
    function Withdraw() public onlyOwner{

        //bool success=payable(msg.sender).send(address(this).balance);
        //payable(msg.sender).transfer(address(this).balance);
        (bool success,)=payable(msg.sender).call{value:address(this).balance,gas: 1 }("");

        require(success,"Transfer Failed");
    }
    //lesson2-5 ERC20 standard
    function approve(address spender,uint256 amount) public {
        allowance[msg.sender][spender]=amount;
    }
    //this function is not safe
    function approvebug(address boss,address spender, uint256 amount) public {
        allowance[boss][spender]=amount;
    }

    function transfer(address receiption, uint256 amount) public {
        require(balance[msg.sender]>=amount,"Not enough balance");
        balance[msg.sender]-=amount;
        balance[receiption]+=amount;

        emit TransferOccurred(msg.sender,receiption,amount);
    }
    //use allowance
    function transferFrom(address from,address to,uint256 amount) public {
        require(msg.sender!=to,"can not transfer to youself");
        require(allowance[from][msg.sender]>=amount,"Not enough allowance");
        require(balance[from]>=amount,"From not enough balance");
        allowance[from][msg.sender]-=amount;
        balance[from]-=amount;
        balance[to]+=amount;
        emit TransferOccurred(from, to, amount);
    }
    
    function getBalance(address account) public view returns(uint256){
        return balance[account];
    }

    function getAllowance(address from, address to) public view returns(uint256){
        return allowance[from][to];
    }

}