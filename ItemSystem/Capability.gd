class_name Capability
extends Node

@export var operand_string: String = ""
var operand: Node

## Don't override this function! Override _utilize instead
func utilize():
	assert(operand != null, "operand in " + name + " was not refrenced and is null!")
	_utilize()
	
func _utilize():
	pass
