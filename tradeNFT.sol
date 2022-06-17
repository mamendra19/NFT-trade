pragma solidity ^0.8.0;
// SPDX-License-Identifier: MIT
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/token/ERC1155/ERC1155.sol";
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/utils/Strings.sol";
contract tradeNFT{
    mapping(address=>mapping(uint256=>Listing)) public listings;
    mapping(address=>uint256) public balances;
struct Listing {
    uint256 price;
    address seller;}
function addListing(uint256 price, address contractAddr,uint256 tokenId) public{
    ERC1155 token=ERC1155(contractAddr);
    require(token.balanceOf(msg.sender,tokenId)>0,"caller must own given token");
    require(token.isApprovedForAll(msg.sender,address(this)),"Contract nmust be approved");
listings[contractAddr][tokenId]=Listing(price,msg.sender);
}
function purchase(address contractAddr,uint256 tokenId,uint256 amount )public payable{
    Listing memory item= listings[contractAddr][tokenId];
    require(msg.value>=item.price*amount,"insufficient funds sent");
    balances[item.seller]+=msg.value;
    ERC1155 token= ERC1155(contractAddr);
    token.safeTransferFrom(item.seller,msg.sender,tokenId,amount,"");

}
function withdraw(uint256 amount, address payable destAddr)public{
    require(amount<=balances[msg.sender],"insufficient funds");
    destAddr.transfer(amount);
    balances[msg.sender]-=amount;}}
