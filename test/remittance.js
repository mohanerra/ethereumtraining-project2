var Remittance = artifacts.require("./Remittance.sol");
// var keccak256 = require('js-sha3').keccak256;
var createKeccakHash = require('keccak');

contract('Remittance', function(accounts) {

    var ownerAddress = web3.eth.accounts[0];
    var bobAddress = web3.eth.accounts[1];
    var carolAddress = web3.eth.accounts[2];

    var bobPassword = "pwd1";
    var carolPassword = "pwd2";
    // var passwordHash = '0x'+createKeccakHash('keccak256').update(carolAddress+bobPassword).digest('hex');

    // var etherToSeed = 2;

    var contract;

    beforeEach( function(){
        return Remittance.new({from: ownerAddress})
        .then( function(instance){
            contract = instance;
            contract.LogHash( function(err, result) {
                if(err){
                    console.log("error occurred", err);
                    return error(err);
                }
                console.log("Event emitted for Hash: " + result.args.value);
            });

            contract.LogAmount(function(err, result) {
                if(err){
                    console.log("error occurred", err);
                    return error(err);
                }
                console.log("Event emitted for Amount transfer: " + result.args.value);
            });

        });
    });

    it("should deploy add a Remittee with correct ether to be seeded", function(){
        var etherToSeed = web3.toWei(2, "ether");
        console.log("contracts seeded amount", etherToSeed);

        return contract.generateHash(carolAddress, bobPassword)
        .then(function(_passwordHash){
            return contract.addRemittee(_passwordHash, carolAddress, {from: ownerAddress, value: etherToSeed})
            .then(function(){
                return contract.getRemitteesAmount(carolAddress)
                .then(function(_amount){
                    assert(_amount==etherToSeed, "ether is not sent to the contract")
                })
            })
        })
    });

    it("should remit the ether from contract to Carol", function(){
        var etherToSeed = web3.toWei(2, "ether");
        var carolsBalanceBeforeRemit = web3.fromWei(web3.eth.getBalance(carolAddress).toNumber(), "ether");
        console.log("carolsBalanceBeforeRemit ", carolsBalanceBeforeRemit);  
        console.log("carols address: " + carolAddress);
        
        var contractBalanceBeforeRemit =  web3.fromWei(web3.eth.getBalance(contract.address).toNumber(), "ether");
        
        return contract.generateHash(carolAddress, bobPassword)
        .then(function(_passwordHash){
            return contract.addRemittee(_passwordHash, carolAddress, {from: ownerAddress, value: etherToSeed})
            .then(function(){
                return contract.getRemitteesAmount(carolAddress)
                .then(function(_amount){
                    assert(_amount==etherToSeed, "ether is not sent to the contract")
                    return contract.remit(bobPassword, {from:carolAddress})
                    .then(function(){
                        var carolsBalanceAfterRemit = web3.fromWei(web3.eth.getBalance(carolAddress).toNumber(), "ether");
                        var contractBalanceAfterRemit =  web3.fromWei(web3.eth.getBalance(contract.address).toNumber(), "ether");

                        console.log("carolsBalanceAfterRemit ", carolsBalanceAfterRemit);

                        assert.equal( (carolsBalanceAfterRemit - carolsBalanceBeforeRemit) >0 , true, "carol was not remitted correctly");
                    })
                })
            })
        })
        
        // return contract.remit(bobPassword, {from: carolAddress})
        // .then( function(_txn){
        //     // console.log("transaction: ", _txn);
        //     // console.log("gasUsed: ", _txn.receipt.gasUsed);
        //     // console.log("gas price: ", web3.eth.getGasPrice());
        //     var carolsBalanceAfterRemit = web3.fromWei(web3.eth.getBalance(carolAddress).toNumber(), "ether");
        //     var contractBalanceAfterRemit =  web3.fromWei(web3.eth.getBalance(contract.address).toNumber(), "ether");

        //     console.log("carolsBalanceAfterRemit ", carolsBalanceAfterRemit);
        //     console.log("contractBalanceAfterRemit ", contractBalanceAfterRemit);

        //     assert.equal( (carolsBalanceAfterRemit - carolsBalanceBeforeRemit) >0 , true, "carol was not remitted correctly");
        //     assert.equal( contractBalanceAfterRemit, 0, "contract balance was not remitted completely");

        //     return contract.computedPasswordsHash()
        //     .then( function(_computedPasswordsHash){
        //         console.log("computedHash in the contract: ", _computedPasswordsHash);
        //     })
        // })

    });

// //This is only added for Test purposes to check the hash computed at client side and hash computed in contract    
    // it("should generate password hash", function(){
    //     console.log("inside generate password hash");
    //     console.log("password hash at client: ", createKeccakHash('keccak256').update(carolAddress+bobPassword).digest('hex'));
    //     console.log("carols address: " + carolAddress);

    //     return contract.passwordHash()
    //     .then (function(_hash){
    //         console.log("password hash in the contract is: ", _hash);
    //         return contract.carolAddress()
    //         .then(function(_carolAddress){
    //             console.log('carol address in contract is : ', _carolAddress);
    //         })
    //     })
        

    // })

});
