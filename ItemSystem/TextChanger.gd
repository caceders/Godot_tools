class_name TextChanger
extends Capability

func _utilize():
	var coins = operand as ResourcePool
	coins.remove_from_amount(10)
