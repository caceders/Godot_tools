class_name Capability
extends Resource

enum Type{
	PASSIVE,
	ACTIVE
}

var _type : Type
var _ID: int
var _operand_string: String

var _operand: Node

func refrence_operand(operand: Node):
	_operand = operand

## Don't override this function! Override _utilize instead
func utilize():
	## Put shit here if needed for every capability
	_utilize()
	
func _utilize():
	pass
	
func _init():
	push_error("Capability does not implement constructor!")
