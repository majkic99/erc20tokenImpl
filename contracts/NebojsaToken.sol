pragma solidity ^0.8.0;
// SPDX-License-Identifier: UNLICENSED
import "./interfaces/ERC20Token.sol";

contract NebojsaToken is ERC20Token{

    uint supply;
    mapping (address => uint) balanceSheet;
    mapping (address => mapping (address => uint)) allowances;
    mapping (address => bool) receivedFreeTokens;

    event FaucetTurnedOn(address, uint);

    constructor(){

    }

    function name() public pure override returns (string memory){
        return 'NebojsaToken';
    }
    
    function symbol() public pure override returns (string memory){
        return 'NBTK';
    }
    
    function totalSupply() public view override returns (uint){
        return supply;
    }
    
    function decimals() public pure override returns (uint8){
        return 8;
    }

    function balanceOf(address _owner) public view override returns (uint){
        return balanceSheet[_owner];
    }

    function allowance(address _owner, address _spender) public view override returns (uint) {
        return allowances[_owner][_spender];
    }
    
    function faucet(uint amount) public {
        //amount requested must be less than one NebojsaToken
        require(receivedFreeTokens[msg.sender] == false);
        require(amount < 100000000);
        receivedFreeTokens[msg.sender] = true;
        balanceSheet[msg.sender] += amount;
        supply += amount;
        emit FaucetTurnedOn(msg.sender, amount);
    }

    function transfer(address _to, uint256 value) public override returns (bool success){
        //require (balanceSheet[msg.sender] >= value);
        require(_to != address(0));
        balanceSheet[msg.sender] -= value;
        balanceSheet[_to] += value;
        emit Transfer(msg.sender, _to, value);
        return true;
    }

    function approve(address _spender, uint256 _value) public override returns (bool success){
        //require (balanceSheet[msg.sender] >= _value);
        allowances[msg.sender][_spender] = _value;
        emit Approval(msg.sender, _spender, _value);
        return true;
    }
    
    function transferFrom(address _from, address _to, uint256 _value) public override returns (bool success){
        require(_from != address(0) && _to != address(0));
        //require(allowances[_from][msg.sender] >= _value);
        allowances[_from][msg.sender] -= _value;
        balanceSheet[_from] -= _value;
        balanceSheet[_to] += _value;
        emit Transfer(_from, _to, _value);
        return true;
    }
}