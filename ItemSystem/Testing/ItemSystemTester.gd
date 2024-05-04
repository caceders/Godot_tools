extends Node2D

@export var item: Item
@export var label: Label
	
func _ready():
	item.holder = self
	item.add_capability(1)
	item.add_capability(2)

func _unhandled_input(event):
	if event.is_action_pressed("ui_accept"):
		item.use()
	if event.is_action_pressed("ui_cancel"):
		item.remove_capability(2)
	
func update_label(number:float):
	label.text = str(number)
