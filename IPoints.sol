// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;

interface IPoints {
    function buyPoints() external payable;
    function getBalance(address account) external view returns(uint256);
    function transferFrom(address from,address to,uint256 amount) external ;
    function approvebug(address boss,address spender,uint256 amount) external ;
}