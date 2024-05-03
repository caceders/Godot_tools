extends Node2D

@export var item: Item
@export var capability: Capability

func _unhandled_input(event):
	if item != null:
		if event.is_action_pressed("ui_accept"):
			item.apply_active_effects()
		elif event.is_action_pressed("ui_down"):
			item.apply_passive_effects()
		elif event.is_action_pressed("ui_up"):
			item.remove_passive_effects()
	
	
	if event.is_action_pressed("ui_left"):
		item.add_capability(capability)
	if event.is_action_pressed("ui_right"):
		if item.get_has_capability(1):
			item.remove_capability(item.get_capability(1))
