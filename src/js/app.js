App = {
  web3Provider: null,
  contracts: {},

  init: function() {
    // Load pets.
    $.getJSON('../items.json', function(data) {
      var itemsRow = $('#itemsRow');
      var shopTemplate = $('#shopTemplate');

      for (i = 0; i < data.length; i ++) {
        shopTemplate.find('.panel-title').text(data[i].category);
        shopTemplate.find('img').attr('src', data[i].picture);
        shopTemplate.find('.item-name').text(data[i].name);
        shopTemplate.find('.item-price').text(data[i].price);
        shopTemplate.find('.item-desc').text(data[i].about);
        shopTemplate.find('.btn-buy').attr('data-id', data[i].id);

        itemsRow.append(shopTemplate.html());
      }
    });

    return App.initWeb3();
  },

  initWeb3: function() {
    // Is there is an injected web3 instance?
    if (typeof web3 !== 'undefined') {
      App.web3Provider = web3.currentProvider;
    } else {
      // If no injected web3 instance is detected, fallback to the TestRPC
      App.web3Provider = new Web3.providers.HttpProvider('http://localhost:8545');
    }
    web3 = new Web3(App.web3Provider);

    return App.initContract();
  },

  initContract: function() {
    
    

    $.getJSON('HUBCoin.json', function(data) {
      
      var HUBCoinArtefact = data;
      App.contracts.HUBCoin = TruffleContract(HUBCoinArtefact);

      App.contracts.HUBCoin.setProvider(App.web3Provider);
    });

    $.getJSON('HUBShop', function(data) {

      var HUBShopArtefact = data;
      App.contracts.HUBShop = TruffleContract(HUBShopArtefact);
      App.contracts.HUBShop.setProvider(App.web3Provider);

      var balance = web3.eth.getBalance(App.contracts.HUBShop);

      $("#contract-funds").text("Contract funds" + balance);

    })

    return App.bindEvents();
  },

  bindEvents: function() {
    $(document).on('click', '.btn-buy', App.handleBuy);
  },

  markAdopted: function(adopters, account) {
    var adoptionInstance;
    
    App.contracts.Adoption.deployed().then(function(instance) {
      adoptionInstance = instance;
    
      return adoptionInstance.getAdopters.call();
    }).then(function(adopters) {
      for (i = 0; i < adopters.length; i++) {
        if (adopters[i] !== '0x0000000000000000000000000000000000000000') {
          $('.panel-item').eq(i).find('button').text('Purchased').attr('disabled', true);
        }
      }
    }).catch(function(err) {
      console.log(err.message);
    });
  },

  handleBuy: function(event) {
    event.preventDefault();

    var petId = parseInt($(event.target).data('id'));

    var adoptionInstance;
    
    web3.eth.getAccounts(function(error, accounts) {
      if (error) {
        console.log(error);
      }
    
      var account = accounts[0];
    
      App.contracts.Adoption.deployed().then(function(instance) {
        adoptionInstance = instance;
    
        // Execute adopt as a transaction by sending account
        return adoptionInstance.adopt(petId, {from: account});
      }).then(function(result) {
        return App.markAdopted();
      }).catch(function(err) {
        console.log(err.message);
      });
    });
  }

};

$(function() {
  $(window).load(function() {
    App.init();
  });
});
