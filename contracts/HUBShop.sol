pragma solidity ^0.4.11;

contract HUBShop {
    
    // Product owner - can add and delete products
    address _owner;
    
    // Product description
    struct Product {
        string name;
        uint256 price;
        string ipfsImageHash;
    }
    
    mapping(uint256 => Product) _products;
    uint256 _numberOfProducts = 0;
    
    function HUBShop() {
        _owner = msg.sender;
    }
    
    
    function () payable {
        throw;
    }
    
    function addProduct(string name, 
                        uint256 price, 
                        string ipfsImageHash)
                        returns (uint256) 
    {
        //require(msg.sender == _owner);
        _numberOfProducts += 1;
        _products[_numberOfProducts] = Product({
            name: name,
            price: price,
            ipfsImageHash: ipfsImageHash
        });
        return _numberOfProducts;
    }
    
    function getProduct(uint256 productId)
                        constant 
                        returns (string) 
    {
        require(_products[productId].price != 0);
        return _products[productId].name;
    }
    
    function deleteProduct(uint256 productId)
                        returns (uint256) 
    {
        // require(msg.sender == _owner);
        require(_products[productId].price != 0);
        _products[productId] = Product({
            name: "",
            price: 0,
            ipfsImageHash: ""
        });
        return productId;
    }
    
    function getPrice(uint256 productId) constant returns (uint256) {
        return _products[productId].price;
    }

    function getIPFSHash(uint256 productId) constant returns (string) {
        return _products[productId].ipfsImageHash;
    } 
    
    function buyProduct(uint256 productId)
                payable 
    {
    
        require(_products[productId].price <= msg.value);
        this.transfer(msg.value);
    }
    
    function pullFunds(address recipient, uint256 amount)
                            payable 
    {
        recipient.send(amount);
    }
    
}