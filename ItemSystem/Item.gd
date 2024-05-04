class_name Item
extends Node

@export var _capabilities: Array[Capability]

static var CapabilityIDs: Dictionary = {
	1: TextChanger,
	2: TextResetter
}
var _holders_parent: Node = null

func refrence_holders_parent(parent:Node):
	_holders_parent = parent

func add_capability(id: int):
	assert(id in CapabilityIDs.keys(), "Capability id " + str(id) + "non existing")
	
	var new_capability = CapabilityIDs[id].new() as Capability
	_capabilities.append(new_capability)
	_refrence_operand(new_capability)
	# Utilize capability if passive
	if new_capability.type == new_capability.Type.PASSIVE:
		new_capability.utilize()

func remove_capability(id: int):
	for capability in _capabilities:
		if capability.ID == id:
			_capabilities.erase(capability)
			return

func get_active_capability_ids() -> Array[int]:
	var capabilityIDs = []
	for capability in _capabilities:
		capabilityIDs.append(capability.ID)
	return capabilityIDs
	

func use():
	for capability in _capabilities:
		if capability.type == capability.Type.ACTIVE:
			capability.utilize()

func _ready():
	for capability in _capabilities:
		_refrence_operand(capability)

func _refrence_operand(capability: Capability):
	capability.refrence_operand(_holders_parent.get_node(capability.operand_string))
