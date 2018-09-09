pragma solidity ^0.4.6;

contract Remittance {

    bytes32 public passwordHash;

    address owner;

    constructor(bytes32 _passwordHash) public payable {
        owner = msg.sender;
        require(_passwordHash.length > 0, "password hash is empty");
        require(msg.value > 0, "invalid amount to seed into contract");
        passwordHash = _passwordHash;

        address(this).transfer(msg.value);
    }

    function remit(string _bobPassword, string _carolPassword) public payable {
        require(address(this).balance > 0, "contract doesnt have enough funds to remit");
        require(bytes(_bobPassword).length > 0, "bob password is empty");
        require(bytes(_carolPassword).length > 0, "carol password is empty");
        bytes32 computedPasswordsHash = keccak256(abi.encodePacked(_bobPassword, _carolPassword));
        require(computedPasswordsHash == passwordHash, "passed passwords doesnt match");

        msg.sender.transfer(address(this).balance);
    }

}
