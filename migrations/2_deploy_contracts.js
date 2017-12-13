var HUBCoin = artifacts.require("HUBCoin");
var HUBShop = artifacts.require("HUBShop");

module.exports = function(deployer) {
    deployer.deploy(HUBCoin);
    deployer.deploy(HUBShop);
};