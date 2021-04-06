pragma solidity ^0.8.0;
// SPDX-License-Identifier: UNLICENSED
import "./interfaces/ERC20Token.sol";

contract NebojsaToken is ERC20Token{

    string override public name = 'NebojsaToken';
    string override public symbol = 'NBTK';
    uint override public totalSupply;
    uint8 override public decimals = 8;
    mapping (address => uint) balanceSheet;
    mapping (address => mapping (address => uint)) allowances;
    mapping (address => bool) receivedFreeTokens;
    event FaucetTurnedOn(address, uint);

    function balanceOf(address _owner) public view override returns (uint){
        return balanceSheet[_owner];
    }

    function allowance(address _owner, address _spender) public view override returns (uint) {
        return allowances[_owner][_spender];
    }
    
    function faucet(uint amount) public {
        //amount requested must be less or equal to one NebojsaToken
        require(receivedFreeTokens[msg.sender] == false, 'Already received free tokens');
        require(amount <= 100000000, 'You want too much');
        receivedFreeTokens[msg.sender] = true;
        balanceSheet[msg.sender] += amount;
        totalSupply += amount;
        emit FaucetTurnedOn(msg.sender, amount);
    }

    function approve(address _spender, uint256 _value) public override returns (bool success){
        allowances[msg.sender][_spender] = _value;
        emit Approval(msg.sender, _spender, _value);
        return true;
    }

    function transfer(address _to, uint256 _value) public override returns (bool success){
        basicTransfer(msg.sender, _to, _value);
        return true;
    }
    
    function transferFrom(address _from, address _to, uint256 _value) public override returns (bool success){
        require(allowances[_from][msg.sender] >= _value, 'Not enough allowance');
        allowances[_from][msg.sender] -= _value;
        basicTransfer(_from, _to, _value);
        return true;
    }

    function basicTransfer(address _from, address _to, uint _value) internal{
        require (balanceSheet[_from] >= _value, 'Balance not enough');
        require(_from != address(0) && _to != address(0),'Bad addresses');
        balanceSheet[_from] -= _value;
        balanceSheet[_to] += _value;
        emit Transfer(_from, _to, _value);
    }

}