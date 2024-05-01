class_name VisualControllerSuddenAnimation2D extends Node
## Component for adding sudden animations to the visual controller.
##
## Must be child of Visual Controller!
## Read documentation for VisualController2D First
## To use add as a child of a Visual Controller. Connect the
## "visual response" method of this node to the relevant signal

## Name of the animation to play
@export var sudden_animation: String = "placeholder_animation"
@export var animation_priority: int = 0

@onready var parent_visual_controller2D: VisualController2D = get_parent()


## Causing sudden animation to be played on parent. Usually played
## as a response to a signal
func visual_response():
	parent_visual_controller2D.play_sudden_animation(sudden_animation, animation_priority)
