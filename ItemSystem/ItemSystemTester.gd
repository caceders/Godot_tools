extends Node2D

@export var capability: Capability
@export var label: Label

func reference_operands():
	capability.operand = (get_node(capability.operand_string))
	
func _ready():
	reference_operands()
	pass

func _unhandled_input(event):
	if event.is_action_pressed("ui_accept"):
		capability.utilize()

func update_label(number:float):
	label.text = str(number)
