class_name TextChanger
extends Capability

func _init():
	_type = Type.ACTIVE
	_ID = 1
	_operand_string = "Coins"

func _utilize():
	var coins = _operand as ResourcePool
	coins.remove_from_amount(10)
