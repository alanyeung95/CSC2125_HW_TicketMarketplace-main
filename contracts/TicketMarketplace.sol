// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.20;

import {ITicketNFT} from "./interfaces/ITicketNFT.sol";
import {IERC20} from "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import {TicketNFT} from "./TicketNFT.sol";
import {Math} from "@openzeppelin/contracts/utils/math/Math.sol"; 
import {ITicketMarketplace} from "./interfaces/ITicketMarketplace.sol";
import "hardhat/console.sol";

contract TicketMarketplace is ITicketMarketplace {
    // hardhat official document is useful
    // https://hardhat.org/tutorial/writing-and-compiling-contracts

    ITicketNFT public ticketNFT;
    address public owner;
    address public ERC20Address;
    address public nftContract;
    uint128 public currentEventId = 0;
    uint128 public currentTicketId = 0;

    struct Event {
        uint128 nextTicketToSell;
        uint128 maxTickets;
        uint256 pricePerTicket;
        uint256 pricePerTicketERC20;
    }

    mapping(uint128 => Event) public events;
    
    constructor(address _erc20TokenAddress) {
        ERC20Address = _erc20TokenAddress;  // set ERC20 token address
        ticketNFT = new TicketNFT(""); 
        nftContract = address(ticketNFT);
        owner = msg.sender;
    }

    function createEvent(uint128 maxTickets, uint256 pricePerTicket, uint256 pricePerTicketERC20) external override {
        require(msg.sender == owner, "Unauthorized access");

        Event memory newEvent = Event({
            nextTicketToSell: 0,
            maxTickets: maxTickets,
            pricePerTicket: pricePerTicket,
            pricePerTicketERC20: pricePerTicketERC20
        });

        events[currentEventId] = newEvent;

        emit EventCreated(currentEventId, maxTickets, pricePerTicket, pricePerTicketERC20);

        currentEventId++;
    }

    function setMaxTicketsForEvent(uint128 eventId, uint128 newMaxTickets) external override {
        require(msg.sender == owner, "Unauthorized access");
        require(newMaxTickets >= events[eventId].maxTickets, "The new number of max tickets is too small!");

        events[eventId].maxTickets = newMaxTickets;

        emit MaxTicketsUpdate(eventId, newMaxTickets);
    }

    function setPriceForTicketETH(uint128 eventId, uint256 price) external override {
        require(msg.sender == owner, "Unauthorized access");

        events[eventId].pricePerTicket = price;

       emit PriceUpdate(eventId, price, "ETH");
    }

    function setPriceForTicketERC20(uint128 eventId, uint256 price) external override {
        require(msg.sender == owner, "Unauthorized access");

        events[eventId].pricePerTicketERC20 = price;

        emit PriceUpdate(eventId, price, "ERC20");
    }

    function buyTickets(uint128 eventId, uint128 ticketCount) payable external override {
        uint256 totalPrice;

        // use unchecked block to allow overflow happen
        unchecked {
            totalPrice = events[eventId].pricePerTicket * ticketCount;
        }

        require(totalPrice / ticketCount == events[eventId].pricePerTicket, "Overflow happened while calculating the total price of tickets. Try buying smaller number of tickets.");
        require(msg.value >= totalPrice, "Not enough funds supplied to buy the specified number of tickets.");
        require(ticketCount <= events[eventId].maxTickets, "We don't have that many tickets left to sell!");

        for (uint128 i = 0; i < ticketCount; i++) {
            uint256 nftId = (uint256(eventId) << 128) + currentTicketId;
            ticketNFT.mintFromMarketPlace(msg.sender, nftId);
            currentTicketId++;
        }

    }

    function buyTicketsERC20(uint128 eventId, uint128 ticketCount) external override {
        /*
        
        // use unchecked block to allow overflow happen
        unchecked {
            totalPrice = events[eventId].pricePerTicketERC20 * ticketCount;
        }

        require(totalPrice / ticketCount == events[eventId].pricePerTicketERC20, "Overflow happened while calculating the total price of tickets. Try buying smaller number of tickets.");

        _processTicketPurchase(eventId, ticketCount);

        emit TicketsBought(eventId, ticketCount, "ERC20");
        */
    }

    function setERC20Address(address newERC20Address) external override {
        require(msg.sender == owner, "Unauthorized access");

        ERC20Address = newERC20Address;

        emit ERC20AddressUpdate(newERC20Address);
    }
}
