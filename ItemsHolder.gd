class_name ItemsHolder
extends Node

@export var _items: Array[Item] = []
var selected: Item = null
var _selected_item_index: int = 0

func use_selected_item():
	if selected == null:
		return
	selected.use()

func select_item(item: Item):
	selected = item
	_selected_item_index = _items.find(item, 0)

func select_next_item():
	if _selected_item_index == len(_items) - 1:
		_selected_item_index = 0
	selected = _items[_selected_item_index]

func select_previous_item():
	if _selected_item_index == 0:
		_selected_item_index = len(_items) - 1
	selected = _items[_selected_item_index]

func add_item(item: Item):
	_items.append(item)
	item.refrence_holders_parent(get_parent())
	add_child(item)

func remove_item(item: Item):
	_items.erase(item)
	remove_child(item)

func get_items():
	return _items

func _ready():
	for item in _items:
		item.refrence_holders_parent(get_parent())
