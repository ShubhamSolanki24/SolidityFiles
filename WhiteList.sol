//SPDX-License-Identifier: MIT

pragma solidity ^0.8.9;

import "@openzeppelin/contracts/token/ERC1155/ERC1155.sol";

contract ERC1155Whitelist is ERC1155{
    uint constant public NFTPrice = 0.2 ether;
    mapping(address => bool) public isWhilelist;
    address public owner = msg.sender;
    modifier onlyOwner(){
        require(msg.sender==owner,"Only Owner has power");
        _;
    }
    modifier onlyWhitelisted(address _address){
        require(isWhilelist[_address],"Should be Whitelisted");
        _; 
    }
    constructor() ERC1155(" "){
        isWhilelist[owner] = true;
    }

    function addUser(address _toWhitelist) public onlyOwner{
        isWhilelist[_toWhitelist] = true;
    }

    function mintBatch(address _to, uint256[] memory _ids, uint256[] memory _amounts, bytes memory _data) public onlyWhitelisted(msg.sender) 
    payable{
        uint Totalsum=0;
        for(uint i=0;i<_amounts.length;i++){
            Totalsum+=_amounts[i];
        }
        require(Totalsum<=5,"You can mint atmost 5 NFT");
        uint256 price = Totalsum*NFTPrice;
        require(msg.value >= price, "Not enough ETH sent; check price!");
        _mintBatch(_to, _ids, _amounts, _data);
    }
}
