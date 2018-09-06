var Remittance = artifacts.require("./Remittance.sol");
var keccak256 = require('js-sha3').keccak256;

var bobPassword = "pwd1";
var carolPassword = "pwd2";
var bobPasswordHash = '0x'+keccak256(bobPassword);
var carolPasswordHash = '0x'+keccak256(carolPassword);

module.exports = function(deployer) {

  deployer.deploy(Remittance, bobPasswordHash, carolPasswordHash, {from: web3.eth.accounts[0], value: web3.toWei(2,"ether")});
};
                    