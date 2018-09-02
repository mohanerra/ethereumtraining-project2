var Remittance = artifacts.require("./Remittance.sol");

contract('Remittance', function(accounts) {

    var ownerAddress = web3.eth.accounts[0];
    var bobAddress = web3.eth.accounts[1];
    var carolAddress = web3.eth.accounts[2];

    var bobPassword = "pwd1";
    var carolPassword = "pwd2";
    var etherToSeed = 2;

    var contract;

    beforeEach( function(){
        return Remittance.new(bobPassword, carolPassword, {from: ownerAddress, value: web3.toWei(etherToSeed, "ether")})
        .then( function(instance){
            contract = instance;
        });
    });

    it("should deploy Remittance contract with correct ether to be seeded", function(){
        var etherSeeded = web3.fromWei(web3.eth.getBalance(contract.address).toNumber(), "ether");
        console.log("contracts seeded amount", etherSeeded);
        assert.equal(etherSeeded, etherToSeed);
    });

    it("should remit the ether from contract to Carol", function(){
        var carolsBalanceBeforeRemit = web3.fromWei(web3.eth.getBalance(carolAddress).toNumber(), "ether");
        console.log("carolsBalanceBeforeRemit ", carolsBalanceBeforeRemit);  
        
        var contractBalanceBeforeRemit =  web3.fromWei(web3.eth.getBalance(contract.address).toNumber(), "ether");
        return contract.remit(bobPassword, carolPassword, {from: carolAddress})
        .then( function(_txn){
            console.log("transaction: ", _txn);
            console.log("gasUsed: ", _txn.receipt.gasUsed);
            console.log("gas price: ", web3.eth.getGasPrice());
            var carolsBalanceAfterRemit = web3.fromWei(web3.eth.getBalance(carolAddress).toNumber(), "ether");
            var contractBalanceAfterRemit =  web3.fromWei(web3.eth.getBalance(contract.address).toNumber(), "ether");

            console.log("carolsBalanceAfterRemit ", carolsBalanceAfterRemit);
            console.log("contractBalanceAfterRemit ", contractBalanceAfterRemit);

            assert.equal( (carolsBalanceAfterRemit - carolsBalanceBeforeRemit) >0 , true, "carol was not remitted correctly");
            assert.equal( contractBalanceAfterRemit, 0, "contract balance was not remitted completely");
        })

    });

});