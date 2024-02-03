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
    }

    function buyTicketsERC20(uint128 eventId, uint128 ticketCount) external override {
    }

    function setERC20Address(address newERC20Address) external override {
        require(msg.sender == owner, "Unauthorized access");

        ERC20Address = newERC20Address;

        emit ERC20AddressUpdate(newERC20Address);
    }

    function _processTicketPurchase(uint128 eventId, uint128 ticketCount) private {
    }
}
