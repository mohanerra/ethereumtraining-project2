var Remittance = artifacts.require("./Remittance.sol");

var bobPassword = "pwd1";
var carolPassword = "pwd2";
module.exports = function(deployer) {

  deployer.deploy(Remittance, bobPassword, bobPassword, {from: web3.eth.accounts[0], value: web3.toWei(2,"ether")});
};
                    