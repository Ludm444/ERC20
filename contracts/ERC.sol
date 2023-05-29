// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;

import "./ERC20.sol";

contract ERC  is ERC20 {

    constructor (string memory name_, string memory symbol_, uint initialSuply, address shop) {
        owner = msg.sender;
        _name = name_;
        _symbol = symbol_;
        mint(initialSuply, shop);
    }
    address owner;
    mapping (address => uint) balances;
    mapping (address => mapping (address => uint)) allowances; 
    string _name;
    string _symbol;
    uint totalToken;

    function name() external view returns (string memory) {
        return  _name;
    }

    function symbol() external view returns (string memory) {
        return _symbol;
    }

    function desimals() external pure returns (uint) {
        return 18;
    }

    function totalSuply() external view returns (uint) {
        return totalToken;
    }

    modifier enoughtToken (address _from, uint _amount) {
        require(balanceOf(_from) >= _amount, "not enought token");
        _;
    }

    modifier onlyOwner () {
        require(msg.sender == owner, "you not owner");
        _;
    }


    function balanceOf(address acount) public view returns (uint) {
        return balances[acount];
    }

    function transfer(address to, uint amount) external enoughtToken(msg.sender, amount) {
        balances[msg.sender] -= amount;
        balances[to] += amount;
        emit Transfer(msg.sender, to, amount);
    }

    function allouns(address _owner, address spender) public view returns (uint) {
        return allowances[_owner][spender];
    }

    function mint(uint amount, address shop) public onlyOwner {
        balances[shop] += amount;
        totalToken += amount;
        emit Transfer(address(0), shop, amount);
    }

    function burn(address _from, uint amount) public onlyOwner {
        balances[_from] -= amount;
        totalToken -= amount;
    }

    function approve(address spender, uint amount) public {
        _approve(msg.sender, spender, amount);
    }

    function _approve(address sender, address spender, uint amount) internal virtual{
        allowances[sender][spender] = amount;
        emit Approve(sender, spender, amount);
    }

    function transfFrom(address sender, address resip, uint amount) public enoughtToken(sender, amount) {
        require(allowances[sender][resip] >= amount, "check allowances!");
        allowances[sender][resip] -= amount;
        balances[sender] -= amount;
        balances[resip] += amount;
        emit Approve(sender, resip, amount);
    }
    
}

contract MSC is ERC {
    constructor(address shop) ERC("MSC", "MCT", 30, shop) {}
}

contract MyShop {
    ERC20 public token;
    address payable public owner;
    event Bayer (uint _amount, address indexed _bayer);
    event Sold (uint _amount, address _seller);

    constructor() {
        token = new MSC(address(this));
        owner = payable(msg.sender);
    }

    modifier onlyOwner() {
        require(owner == msg.sender, "you not owner!");
        _;
    }

    function sell (uint _amountToSell) external {
        require(_amountToSell >0 && token.balanceOf(msg.sender) >= _amountToSell, "incorrect amount!");
        uint alowance = token.allouns(msg.sender, address(this));
        require (alowance >= _amountToSell, "check amount!");
        token.transfFrom(msg.sender, address(this), _amountToSell);
        payable(msg.sender).transfer(_amountToSell);
        emit Sold(_amountToSell, msg.sender);
    }

    receive() external payable {
    uint tokensToBuy = msg.value;
    require(tokensToBuy >0, "not enought tokens!");

    uint currentBalance = tocenBalance();
    require(currentBalance >= tokensToBuy, "not tokens!");

    token.transfer(msg.sender, tokensToBuy);
    emit Bayer(tokensToBuy, msg.sender);
    }

    function tocenBalance() public view returns (uint) {
        return token.balanceOf(address(this));
    }

    function GetManey() public onlyOwner {
        owner.transfer(address(this).balance);
    }
}