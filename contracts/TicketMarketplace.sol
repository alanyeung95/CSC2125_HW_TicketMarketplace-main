// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.20;

import {ITicketNFT} from "./interfaces/ITicketNFT.sol";
import {IERC20} from "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import {TicketNFT} from "./TicketNFT.sol";
import {Math} from "@openzeppelin/contracts/utils/math/Math.sol"; 
import {ITicketMarketplace} from "./interfaces/ITicketMarketplace.sol";
import "hardhat/console.sol";

contract TicketMarketplace is ITicketMarketplace {
    ITicketNFT public ticketNFT;
    address public owner;
    address public ERC20Address;
    address public nftContract;
    uint128 public currentEventId = 0;

    constructor(address _erc20TokenAddress) {
        ERC20Address = _erc20TokenAddress;  // set ERC20 token address
        ticketNFT = new TicketNFT(""); // to-ask: empty string?
        nftContract = address(ticketNFT);
        owner = msg.sender;
    }

    function createEvent(uint128 maxTickets, uint256 pricePerTicket, uint256 pricePerTicketERC20) external override {
   }

    function setMaxTicketsForEvent(uint128 eventId, uint128 newMaxTickets) external override {
    }

    function setPriceForTicketETH(uint128 eventId, uint256 price) external override {
    }

    function setPriceForTicketERC20(uint128 eventId, uint256 price) external override {
     }

    function buyTickets(uint128 eventId, uint128 ticketCount) payable external override {
    }

    function buyTicketsERC20(uint128 eventId, uint128 ticketCount) external override {
    }

    function setERC20Address(address newERC20Address) external override {
    }

    function _processTicketPurchase(uint128 eventId, uint128 ticketCount) private {
   }
}
