extends Node2D

@export var targets: Array[Targetable] = []
@export var target_selector: TargetSelector
@export var line_edit: LineEdit

# Called when the node enters the scene tree for the first time.
func _ready():
	for target in targets:
		target_selector.add_to_selection(target)
	
func _process(delta):
	for i in range(target_selector.targets.size()):
		target_selector.targets[i].get_parent().get_node("Label").text = str(i)
	pass
	
	if Input.is_action_just_pressed("ui_left") and not line_edit.has_focus():
		print("sorting")
		target_selector.sort_targets_by(".", "position.x")

	if Input.is_action_just_pressed("ui_up") and not line_edit.has_focus():
		print("sorting")
		target_selector.sort_targets_by(".", "position.y")
	
	if Input.is_action_just_pressed("ui_down") and not line_edit.has_focus():
		print("sorting")
		target_selector.sort_targets_by("String", "text")

	if Input.is_action_just_pressed("ui_right") and not line_edit.has_focus(): 
		print("sorting")
		target_selector.sort_targets_by(".", "position.x", true)
	
	
func _sort_by_search():
	print("sorting")
	target_selector.sort_targets_by("String", "text", false, line_edit.text)
