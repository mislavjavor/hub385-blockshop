pragma solidity ^0.4.8;

contract HUBCoin {
    
    mapping(address => uint256) _balances;
    
    uint256 constant MAX_VALUE = 0.5 ether;
    uint256 _totalIssuedTokens = 0;
    uint256 _endIssuanceTime = now + 1 days;
    
    
    function HUBCoin() {
        
    }
    
    function getBalance(string account) constant returns (uint256) {
        
        address resolvedAccount = getEntry(account);
        require(resolvedAccount != address(0));
        
        return _balances[resolvedAccount];
    }
    
    function send(string receiver, uint256 value) {
        require(_balances[msg.sender] > value);
        
        address receiverAdd = getEntry(receiver);
        require(receiverAdd != address(0));
        
        _balances[msg.sender] -= value;
        _balances[receiverAdd] += value;
    }
    
    function mintTokens() public payable returns (uint256) {
        uint256 valueOfTokens = msg.value;

        require((_totalIssuedTokens + valueOfTokens) < MAX_VALUE);
        require(now < _endIssuanceTime);
        
        _balances[msg.sender] = valueOfTokens;
        _totalIssuedTokens += valueOfTokens;
        
        return valueOfTokens;
    }
    
    /// RESOLVER BEGIN
    
    struct Entry {
        address resolved;
        address owner;
    }
    
    mapping(string => Entry) _entries;
    
    function addEntry(string name, address resolved) {
        require(_entries[name].resolved == address(0));
        _entries[name] = Entry({
            resolved: resolved,
            owner: msg.sender
        });
    }
    
    function changeOwner(string name, address newOwner) {
        require(_entries[name].owner == msg.sender);
        _entries[name].owner = newOwner;
    }
    
    function changeEntry(string name, address resolved) {
        require(_entries[name].owner == msg.sender);
        _entries[name].resolved = resolved;
    }
    
    function getEntry(string name) constant returns (address) {
        return _entries[name].resolved;
    }
    
}