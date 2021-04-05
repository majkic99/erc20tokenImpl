pragma solidity >=0.8.0 <0.9.0;
// SPDX-License-Identifier: UNLICENSED
import "./interfaces/ERC20Token.sol";
contract NebojsaToken is ERC20Token{

   mapping (address => uint) balanceSheet;
    mapping (address => mapping (address => uint)) allowances;
    
    function name() public pure override returns (string memory){
        return 'NebojsaToken';
    }
    
    function symbol() public pure override returns (string memory){
        return 'NBTK';
    }
    
    function totalSupply() public pure override returns (uint){
        return 0;
    }
    
    function decimals() public pure override returns (uint8){
        return 8;
    }

    function balanceOf(address _owner) public view override returns (uint){
        return balanceSheet[_owner];
    }
    
    function transfer(address _to, uint256 value) public override returns (bool success){
        require (balanceSheet[msg.sender] >= value);
        balanceSheet[msg.sender] = 0;
        balanceSheet[_to] += value;
        emit Transfer(msg.sender, _to, value);
        return true;
    }
    
    function allowance(address _owner, address _spender) public view override returns (uint) {
        return allowances[_owner][_spender];
    }
    
    function approve(address _spender, uint256 _value) public override returns (bool success){
        require (balanceSheet[msg.sender] >= _value);
        allowances[msg.sender][_spender] = _value;
        emit Approval(msg.sender, _spender, _value);
        return true;
    }
    
    function transferFrom(address _from, address _to, uint256 _value) public override returns (bool success){
        require(allowances[_from][msg.sender] >= _value);
        allowances[_from][msg.sender] -= _value;
        balanceSheet[_from] -= _value;
        balanceSheet[_to] += _value;
        emit Transfer(_from, _to, _value);
        return true;
    }
}