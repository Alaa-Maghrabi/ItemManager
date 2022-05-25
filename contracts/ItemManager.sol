pragma solidity ^0.7.0;

import "./Ownable.sol";
import "./Item.sol";

contract ItemManager is Ownable{

    enum SupplyChainState{Created, Paid, Delivered}

    struct S_Item{
        Item _item;
        string _identifier;
        uint _itemPrice;
        ItemManager.SupplyChainState _state;
    }

    mapping(uint => S_Item) public items;

    uint itemIndex;

    event SupplyChainStep(uint _itemIndex, uint _step, address _itemAddress);

    function createItem(string memory _identifier, uint _itemPrice) public OnlyOwner{
        Item item = new Item(this, _itemPrice, itemIndex);
        items[itemIndex]._item = item;
        items[itemIndex]._identifier = _identifier;
        items[itemIndex]._itemPrice = _itemPrice;
        items[itemIndex]._state = SupplyChainState.Created;

        emit SupplyChainStep(itemIndex, uint(items[itemIndex]._state), address(items[itemIndex]._item));

        itemIndex++;
    }

    function triggerPayment(uint _itemIndex) payable public{
        require(items[_itemIndex]._itemPrice == msg.value, "Unsufficient amount");
        require(items[_itemIndex]._state == SupplyChainState.Created, "Items doesn't exist or already sold");

        items[_itemIndex]._state = SupplyChainState.Paid;

        emit SupplyChainStep(itemIndex, uint(items[itemIndex]._state), address(items[itemIndex]._item));
    }

    function triggerDelivery(uint _itemIndex) public OnlyOwner{
        require(items[_itemIndex]._state == SupplyChainState.Paid, "Items doesn't exist or already sold");

        items[_itemIndex]._state = SupplyChainState.Delivered;

        emit SupplyChainStep(itemIndex, uint(items[itemIndex]._state), address(items[itemIndex]._item));
    }
}