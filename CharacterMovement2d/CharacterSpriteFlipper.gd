extends Node2D
## Node for flipping sprite based on movement to the right or left

## Made as a way to flip the sprite through a VisualController2D based on
## character-intended movement from the CharacterMovement2D node.

@export var visual_controller2D: VisualController2D
@export var character_movement2D: CharachterMovement2D
@export var movement_sensitivity: float = 0.1

func _process(delta):
	## Changes the direction based on the desired movement direction.
	## Standard is facing right
	if(character_movement2D.movement_direction.x > movement_sensitivity):
		visual_controller2D.flip_sprite(false)
	elif(character_movement2D.movement_direction.x < -movement_sensitivity):
		visual_controller2D.flip_sprite(true)
