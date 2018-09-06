pragma solidity ^0.4.6;

contract Remittance {

    bytes32 public bobPasswordHash;
    bytes32 public carolPasswordHash;
    bytes32 private passwordHash;
    // bytes32 public computedHash;

    address owner;

    constructor(bytes32 _bobPasswordHash, bytes32 _carolPasswordHash) public payable {
        owner = msg.sender;
        require(_bobPasswordHash.length > 0, "bob password is empty");
        require(_carolPasswordHash.length > 0, "carol password is empty");
        require(msg.value > 0, "invalid amount to seed into contract");
        bobPasswordHash = _bobPasswordHash;
        carolPasswordHash = _carolPasswordHash;
        passwordHash = keccak256(abi.encodePacked(bobPasswordHash, carolPasswordHash));

        address(this).transfer(msg.value);
    }

    function remit(string _bobPassword, string _carolPassword) public payable {
        require(address(this).balance > 0, "contract doesnt have enough funds to remit");
        require(bytes(_bobPassword).length > 0, "bob password is empty");
        require(bytes(_carolPassword).length > 0, "carol password is empty");
        bytes32 _bobPasswordHash = keccak256(abi.encodePacked(_bobPassword));
        bytes32 _carolPasswordHash = keccak256(abi.encodePacked(_carolPassword));
        bytes32 passedPasswordsHash = keccak256(abi.encodePacked(_bobPasswordHash, _carolPasswordHash));
        // computedHash = passedPasswordsHash;
        require(passedPasswordsHash == passwordHash, "passed passwords doesnt match");

        msg.sender.transfer(address(this).balance);
    }

    // function computeHash(string _bobPassword, string _carolPassword) public pure returns(bytes32 hash) {
    //     bytes32 _bobPasswordHash = keccak256(abi.encodePacked(_bobPassword));
    //     bytes32 _carolPasswordHash = keccak256(abi.encodePacked(_carolPassword));
    //     bytes32 passedPasswordsHash = keccak256(abi.encodePacked(_bobPasswordHash, _carolPasswordHash));
    //     return passedPasswordsHash;
    // }

    // function getPasswordHash() public view returns (bytes32 hash){
    //     return passwordHash;
    // }

}
