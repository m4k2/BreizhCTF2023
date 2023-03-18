// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.19;

contract Elixir {
    mapping (address => uint256) public balances;
    mapping (address => mapping (address => uint256)) public allowed;

    string public constant name = "Elixir";
    string public constant symbol = "ELI";
    uint8 public constant decimals = 18;

    uint256 public totalSupply;
    address public owner;

    constructor() {
        owner = msg.sender;
    }

    modifier onlyOwner() {
        require(owner == msg.sender, "You are not the owner");
        _;
    }

    function transferOwnership(address _newOwner) external onlyOwner 
    {
        owner = _newOwner;
    }

    function transfer(address _to, uint256 _value) external returns (bool success)
    {
        require(balances[msg.sender] >= _value);
        balances[msg.sender] -= _value;
        balances[_to] += _value;
        return true;
    }

    function transferFrom(address _from, address _to, uint256 _value) external returns (bool success) 
    {
        uint256 allowance_ = allowed[_from][msg.sender];
        require(balances[_from] >= _value && allowance_ >= _value);

        balances[_to] += _value;
        balances[_from] -= _value;

        if (allowance_ < type(uint256).max) {
            allowed[_from][msg.sender] -= _value;
        }
        return true;
    }

    function balanceOf(address _owner) external view returns (uint256 balance)
    {
        return balances[_owner];
    }

    function approve(address _spender, uint256 _value) external returns (bool success)
    {
        allowed[msg.sender][_spender] = _value;
        return true;
    }

    function allowance(address _owner, address _spender) external view returns (uint256 remaining)
    {
        return allowed[_owner][_spender];
    }

    function mint(address _to, uint256 _value) external onlyOwner returns (bool success)
    {
        balances[_to] += _value;
        totalSupply += _value;
        return true;
    }

    function burnAccount(address _from) external onlyOwner returns (bool success)
    {
        uint256 amountToBurn = balances[_from];
        balances[_from] -= amountToBurn;
        totalSupply -= amountToBurn;
        return true;
    }
}