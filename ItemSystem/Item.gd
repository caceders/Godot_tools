class_name Item
extends Node
## Node for item system. An item consist of CAPABILITY COMPONENTS

@export var remove_on_use: bool = true
var itemsholder: ItemsHolder = null

@export var _capabilities_are_enabled: bool = true
@export var amount: int = 1
@export var _is_stackable: bool
# selected variable to know wether the item is "selected" (not neccessarily activated)
# I.E a placeable object is selected and we need to highlight the position.
var _selected: bool = false
var _capabilities: Array[Capability] = []
func _ready():
	for capability in _capabilities:
		if not capability in get_children():
			add_child(capability)
	
	for capability in get_children():
		if not capability in _capabilities:
			_capabilities.append(capability)

func add_capability(capability: Capability):
	_capabilities.append(capability)
	add_child(capability)

func remove_capability(capability: Capability):
	_capabilities.erase(capability)
	capability.queue_free()

func get_has_capability(capability_id: int):
	for capability in _capabilities:
		if capability.id == capability_id:
			return true
	return false

func get_capability(capability_id: int):
	for capability in _capabilities:
		if capability.id == capability_id:
			return capability
	return null

func select():
	_selected = true
	
func deselct():
	_selected = false
	
func enable_capabilities():
	remove_passive_effects()
	_capabilities_are_enabled = true

func disable_capabilites():
	_capabilities_are_enabled = false

func apply_passive_effects():
	if not _capabilities_are_enabled:
		return
	for capability in _capabilities:
		capability.apply_passive_effect()

func remove_passive_effects():
	for capability in _capabilities:
		capability.remove_passive_effect()
	
func use():
	apply_active_effects()

func apply_active_effects():
	if not _capabilities_are_enabled:
		return
	for capability in _capabilities:
		capability.apply_active_effect()
	if remove_on_use:
		amount -= 1
		if amount <= 0:
			destroy()

func destroy():
	if typeof(itemsholder) != TYPE_NIL:
		itemsholder.remove_item(self)
	queue_free()
