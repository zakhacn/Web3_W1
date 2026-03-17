// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;

//import the header 
import "./IPoints.sol";

contract PointsManager{
    IPoints public pointsContract;

    constructor(address _pointsAddress){
        pointsContract = IPoints(_pointsAddress);
    }
    //we dont use managercontracts to change allowance ,as usuall
    function changeallowance(uint256 amount) public{
        pointsContract.approvebug(msg.sender,address(this), amount);
    }

    function checkUserPoints(address _user) public view returns(uint256){
        return pointsContract.getBalance(_user);
    }    

    function giftPoints(address _to,uint256 amount) public {
        pointsContract.transferFrom(msg.sender,_to,amount);
    }

}
