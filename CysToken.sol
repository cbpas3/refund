// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;


import "@openzeppelin/contracts/token/ERC20/extensions/ERC20Capped.sol";

contract CysToken is ERC20Capped{
    address payable private _admin;

    modifier onlyAdmin {
      require(msg.sender == _admin, "CysToken: Not authorized to call this function.");
      _;
    }
    
    constructor() ERC20Capped(1000000*10**decimals()) ERC20("CysToken", "CYT") {
        _admin = payable(msg.sender);
    }

    function mint() external payable {
        require(msg.value == 1*10**decimals(), "CysToken: Wrong amount of Eth sent.");
        if(totalSupply() == cap()){
            require(balanceOf(address(this))>= 1000*10**decimals(), "CysToken: Insuffienct tokens in contract.");
            _transfer( address(this) ,msg.sender,1000 * 10**decimals());
        } else{
            _mint(msg.sender,1000*10**decimals());
        } 
    }

    function withdrawEth() external payable onlyAdmin {
        _admin.transfer(address(this).balance);
    }

    function refund() external payable {
        require(address(this).balance >= 5*10**(decimals()-1), "CysToken: Not enough ether to pay.");
        require(balanceOf(msg.sender) >= 1000 * 10**decimals());
        _transfer(msg.sender, address(this) ,1000 * 10**decimals());
        payable(msg.sender).transfer(5*10**(decimals()-1));
    }

// Take what you did in assignment 4 and give the users the ability to transfer their tokens to the contract and receive 0.5 ether for every 1000 tokens they transfer.

// ERC20 tokens don’t have the ability to trigger functions on smart contracts. Users need to give the smart contract approval to withdraw their ERC20 tokens from their balance. See here: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/token/ERC20/ERC20.sol#L136

// The smart contract should block the transaction if the smart contract does not have enough ether to pay the user.

// If another user wants to buy tokens from the contract, and the supply has already been used up, and the contract is holding tokens that other people sent in, it must sell them those tokens at the original price of 1 ether per 1000 tokens.

}
