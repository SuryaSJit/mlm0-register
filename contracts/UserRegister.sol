//SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.0;

// import "hardhat/console.sol";


import "./Token.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import '@openzeppelin/contracts/utils/math/SafeMath.sol';


/**
*@title UserRegister
*@dev This contract registers new user with a referrar address and stores their details with basic token transfer functionalities.
 */

contract UserRegister is Ownable {


    Token public token;

    using SafeMath for uint256;
     
   
    constructor(Token _token) public {
        token = _token;
    }
  
    struct profile  {
        uint256 count;
        address referralCode;
        uint registration_time;
        uint256 level;
        uint256 bonusPercent;
    }

    mapping(address => profile) public user;

    /**
     *@dev Registers user and Token is transferred as registartion fees.
     * Requirements:
     * - the caller must have a balance of at least 100.
     * - should not be a registered user.
     *@param _referralCode represents the address of the user's referrer.
     *Note: This function will register user by paying 100 tokens
     *Already registered users cant avail this function.
     */

    function register (address _referralCode) public {       
        require(user[msg.sender].count==0,"User already registered");
        address owner = owner();
        token.approve(address(this), 100);
        token.transferFrom(msg.sender, address(this), 100);

        user[msg.sender].referralCode= _referralCode;

        if(user[msg.sender].referralCode==owner){
            user[owner].bonusPercent=10;
            user[msg.sender].level=1;
            user[msg.sender].bonusPercent=10;
        }
        else{
            user[msg.sender].level=user[_referralCode].level + 1;
            user[msg.sender].bonusPercent=user[_referralCode].bonusPercent - 1;
        }
        
        user[msg.sender].registration_time= block.timestamp;  
        user[msg.sender].count++;

        uint bonus = (100 * user[_referralCode].bonusPercent)/100;

        token.transfer(_referralCode,bonus);
 
    }

   

}