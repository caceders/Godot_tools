extends Node
## A script drawing the sprites based on their y position, so that sprites higher up appear behind the ones in front

@export var target_selector: TargetSelector

func _ready():
	for child in get_children():
		if child.has_node("DrawTarget"):
			var target = child.get_node("DrawTarget")
			target_selector.add_to_selection(target)

func _process(delta):
	var draw_order: Array[Node2D]
	target_selector.sort_targets_by(".", "position.y")
	for target in target_selector.targets:
		draw_order.append(target.get_parent())
	
	for i in range(draw_order.size()):
		move_child(draw_order[i], i)
