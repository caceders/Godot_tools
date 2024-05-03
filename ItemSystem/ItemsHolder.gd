class_name ItemsHolder
extends Node

@export var _items: Array[Item]
@export var _selected: Item = null
@export var items_activated:bool = true

func _ready():
	if not _items.is_empty():
		for item in _items:
			item.itemsholder = self
			if not item in get_children():
				add_child(item)
	
	for item in get_children():
		if not item in _items:
			_items.append(item)
	
	if items_activated:
		for item in _items:
			item.activate_capabilities()
			item.apply_passive_effects()
	
func add_item(item:Item):
	_items.append(item)
	if items_activated:
		item.apply_passive_effects()

func remove_item(item:Item):
	assert(item in _items)
	_items.erase(item)

func select(item:Item):
	assert(item in _items)
	if _selected != null:
		_selected.deselct()
		item.select()
		_selected = item
	else:
		item.select()
		_selected = item

func get_items():
	return _items

func enable_items():
	for item in _items:
		item.enable_capabilities()

func disable_items():
	for item in _items:
		item.disable_capabilities()
