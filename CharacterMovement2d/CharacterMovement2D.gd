class_name CharackterMovement2D extends Node2D
## Simple class for moving around a CharcterBody2D,

## To use add to a CharacterBody2D. Add relevant speed profiles to the dictionary through the
## inspector. Switch between the profiles by using the "set_active_movement_profile" method.
## To move around change the movement direction variable. Remember to call move_and_slide in parent.
## Add a knockback by calling the knockback method.
@export var body_to_move: CharacterBody2D

#region Variables
## Dictionary of speed profiles and their corresponging speed
@export var speed_profiles = {"still" : 0, "walk" : 400, "sprint" : 800}
## The standard knockback force on this object
@export var standard_applied_knockback_force: float = 800
## Variable varying the knockback-falloff
@export var knockback_reduction: float = 0.15
## Variable for creating intermediate values for speed for smoothing
@export var speed_smoothing: float = 0.7
## Variable for creating intermediate values for direction for smoothing
@export var directional_smoothing: float = 0.2

var movement_direction: Vector2 = Vector2.ZERO

var _active_movement_profile: String = "still"
var _knockback_direction: Vector2 = Vector2.ZERO
var _knockback_force: float = 0
var _smoothed_movement_direction: Vector2 = Vector2.ZERO
var _smoothed_movement_speed: float = 0

@onready var _movement_speed: float = speed_profiles[_active_movement_profile]
#endregion


func _physics_process(delta):
	
	# Caclulate temprorary smoothed intermediate values
	_smoothed_movement_speed = lerp(_smoothed_movement_speed, _movement_speed, speed_smoothing)
	_smoothed_movement_direction = lerp(_smoothed_movement_direction, movement_direction, directional_smoothing)
	var smoothed_velocity: Vector2 = _smoothed_movement_direction * _smoothed_movement_speed + _knockback_direction * _knockback_force
	
	body_to_move.velocity = smoothed_velocity
	
	# Reduce knockback
	_knockback_force = lerp(_knockback_force, 0.0, knockback_reduction)

## Applies knockback with a force and a direction. If no force is given, a standard force is passed.
func knockback(force: float = standard_applied_knockback_force, direction: Vector2 = Vector2.RIGHT):
	_knockback_force = force
	_knockback_direction = direction

## Changes active the movement profile and the corresponding speed
func set_active_movement_profile(type: String):
	_active_movement_profile = type
	_change_speed_through_profile(type)

## Returns true of character is being moved by player
func is_moving() -> bool:
	return _active_movement_profile != "still"


func _change_speed_through_profile(new_profile: String):
	_movement_speed = speed_profiles[new_profile]
