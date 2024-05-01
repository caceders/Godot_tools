@tool
extends Label

@export var tracking_parent: Node2D
@export var resource_name: String	
var resource_pool: ResourcePool

func _ready():
	resource_pool = tracking_parent.get_node(resource_name)

func _process(delta):
	text = resource_name + ": "
	if not Engine.is_editor_hint():
		text += str(snapped(resource_pool.get_amount(), 1))
