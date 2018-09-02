pragma solidity ^0.4.6;

contract Remittance {

    string bobPassword;
    string carolPassword;
    bytes32 passwordHash;

    address owner;
    // uint public amount;

    constructor(string _bobPassword, string _carolPassword) public payable {
        owner = msg.sender;
        require(bytes(_bobPassword).length > 0, "bob password is empty");
        require(bytes(_carolPassword).length > 0, "carol password is empty");
        require(msg.value > 0, "invalid amount to seed into contract");
        bobPassword = _bobPassword;
        carolPassword = _carolPassword;
        passwordHash = keccak256(abi.encodePacked(_bobPassword, carolPassword));

        address(this).transfer(msg.value);
    }

    function remit(string _bobPassword, string _carolPassword) public payable {
        require(address(this).balance > 0, "contract doesnt have enough funds to remit");
        require(bytes(_bobPassword).length > 0, "bob password is empty");
        require(bytes(_carolPassword).length > 0, "carol password is empty");
        bytes32 passedPasswordsHash = keccak256(abi.encodePacked(_bobPassword, _carolPassword));
        require(passedPasswordsHash == passwordHash, "passed passwords doesnt match");

        msg.sender.transfer(address(this).balance);
    }

}
