// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;

interface ERC20 {
    function name() external view returns (string memory);
    function symbol() external view returns (string memory);
    function desimals() external pure returns (uint);
    function totalSuply() external view returns (uint);
    function balanceOf(address acount) external view returns (uint);
    function transfer(address to, uint amount) external;
    function allouns (address _owner, address spender) external view returns (uint);
    function approve (address spender, uint amount) external;
    function transfFrom (address sender, address resip, uint amount) external;
    event Transfer (address indexed from, address indexed to, uint amount);
    event Approve (address indexed owner, address indexed to, uint amount);
}