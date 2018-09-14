var Remittance = artifacts.require("./Remittance.sol");
var createKeccakHash = require('keccak');

var bobPassword = "pwd1";
var carolPassword = "pwd2";
var passwordHash = '0x'+createKeccakHash('keccak256').update(carolAddress+bobPassword).digest('hex');;
var carolAddress = web3.eth.accounts[2];

module.exports = function(deployer) {

  deployer.deploy(Remittance, {from: web3.eth.accounts[0]});
};
                    