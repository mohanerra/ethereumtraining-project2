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

    event LogDetails(address sender, bytes32 hash, uint amount);
    // event LogAmount(address sender, uint amount);


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
        require(_passwordHash[0] != 0, "password hash is empty");
        require(_remittee!=0, "Remittee cannot be empty");
        require(msg.value > 0, "invalid amount to seed into contract");
        emit LogDetails(_remittee, _passwordHash, 0);
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

        uint amountToSend = remittanceStructs[msg.sender].amount;

        require(amountToSend > 0, "You dont have enough funds to remit");

        bytes32 computedPasswordsHash = keccak256(abi.encodePacked(msg.sender, receiverPassword));
        require(computedPasswordsHash == remittanceStructs[msg.sender].paswordHash, "passed passwords doesnt match");

        //set the amount to zero
        remittanceStructs[msg.sender].amount = 0;

        emit LogDetails(msg.sender, computedPasswordsHash, amountToSend);

        msg.sender.transfer(amountToSend);
    }

    function generateHash(address receiverAddress, string receiverPassword) public pure returns(bytes32 hash) {
        return keccak256(abi.encodePacked(receiverAddress, receiverPassword));
    }

    //didnt know how to read structs in javascript tests. Hence creating a helper function to get the values from struct
    function getRemitteesAmount(address remittee) public view onlyOwner returns(uint amt) {
        return remittanceStructs[remittee].amount;
    }

}
