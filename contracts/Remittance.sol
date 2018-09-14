pragma solidity ^0.4.6;

import "./Pausable.sol";

contract Remittance is Pausable{

    // bytes32 public passwordHash;
    // address public carolAddress;

    // bytes32 public computedPasswordsHash;

    struct RemittanceStruct {
        uint amount;
        bytes32 paswordHash;
    }

    mapping(address=>RemittanceStruct) public remittanceStructs;

    // address owner;

    event LogHash(address sender, bytes32 hash);
    event LogAmount(address sender, uint amount);


    // constructor(bytes32 _passwordHash, address _carolAddress) public payable {
    //     owner = msg.sender;
    //     carolAddress = _carolAddress;
    //     require(_passwordHash.length > 0, "password hash is empty");
    //     require(msg.value > 0, "invalid amount to seed into contract");
    //     passwordHash = _passwordHash;
    //     // emit LogHash(msg.sender, passwordHash);
    //     address(this).transfer(msg.value);
    // }

    constructor() public {
    }

    function addRemittee(bytes32 _passwordHash, address _remittee) public onlyOwner payable {
        require(_passwordHash.length > 0, "password hash is empty");
        require(msg.value > 0, "invalid amount to seed into contract");
        emit LogHash(_remittee, _passwordHash);
        RemittanceStruct memory remittanceStruct = RemittanceStruct(msg.value, _passwordHash);
        remittanceStructs[_remittee] = remittanceStruct;
        // address(this).transfer(msg.value);
    }

    // function remit(string _bobPassword, string _carolPassword) public {
    //     require(msg.sender == carolAddress, "You are not authorized to execute remit");
    //     require(address(this).balance > 0, "contract doesnt have enough funds to remit");
    //     require(bytes(_bobPassword).length > 0, "bob password is empty");
    //     // require(bytes(_carolPassword).length > 0, "carol password is empty");
    //     emit LogHash(msg.sender, passwordHash);
    //     computedPasswordsHash = keccak256(abi.encodePacked(_bobPassword, _carolPassword));
    //     emit LogHash(msg.sender, computedPasswordsHash);
    //     // require(computedPasswordsHash == passwordHash, "passed passwords doesnt match");

    //     msg.sender.transfer(address(this).balance);
    // }

    function remit(string receiverPassword) public onlyIfRunning{
        require(remittanceStructs[msg.sender].paswordHash.length > 0, "You are not authorized to execute remit");
        require(remittanceStructs[msg.sender].amount > 0, "You dont have enough funds to remit");

        bytes32 computedPasswordsHash = keccak256(abi.encodePacked(msg.sender, receiverPassword));
        emit LogHash(msg.sender, computedPasswordsHash);
        require(computedPasswordsHash == remittanceStructs[msg.sender].paswordHash, "passed passwords doesnt match");

        emit LogAmount(msg.sender, remittanceStructs[msg.sender].amount);

        msg.sender.transfer(remittanceStructs[msg.sender].amount);
    }

    function generateHash(address receiverAddress, string receiverPassword) public pure returns(bytes32 hash) {
        return keccak256(abi.encodePacked(receiverAddress, receiverPassword));
    }

    //didnt know how to read structs in javascript tests. Hence creating a helper function to get the values from struct
    function getRemitteesAmount(address remittee) public view onlyOwner returns(uint amt) {
        return remittanceStructs[remittee].amount;
    }

}
