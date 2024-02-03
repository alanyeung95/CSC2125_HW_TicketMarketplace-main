// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.20;

import {ERC20} from "@openzeppelin/contracts/token/ERC20/ERC20.sol";
// Uncomment this line to use console.log
// import "hardhat/console.sol";

contract SampleCoin is ERC20 {
    // your code goes here (you can do it!)

    constructor() ERC20("SampleCoin", "SAMP") {
        // For most ERC20 tokens, the standard is to use 18 decimal places, so decimals() = 18
        // This means that 1 token is actually represented internally as 10**18 of the smallest unit
        // 10^18 = 1 token
        // we mint 100 token here
        _mint(msg.sender, 100 * 10**uint(decimals())); 
    }
    
}