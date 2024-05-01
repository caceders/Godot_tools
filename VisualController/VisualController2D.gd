@tool
class_name VisualController2D extends Node
## A class for simplefying changing animations for entities.

## Visual controller playing base animations from animationstates,
## and overiding the base animations with sudden animations.
## The visual controller also controls the sprite2D. In future maybe find
## a way to update the sprite texture when edited.
## To use add to any node. Add a base animation and a string key to the base
## animation dictionary. Only one base animation will be played at a time.
## Change between the animations by calling the "change state" function.
## To play sudden animation add a VisualControllerSuddenAnimation2D node as
## a child of this node.

## A hack to avoid jittering in animations is to set texture changes to
## continues track types. This makes them bypass the blending.
## This is a complete hack - but the only way to bypass blending it
## seems \_Ü_/

## A dictionary of a visual state and an animation
@export var animation_dictionary: Dictionary = {
		"default_visual_state":"placeholder_animation",
		"reset":"placeholder_animation",
		}

@export var sprite_texture: Texture:
	set(texture):
		if sprite2d != null:	
			sprite2d.texture = texture
			sprite_texture = texture

@export var sprite2d: Sprite2D
@export var animation_player: AnimationPlayer
@export var sudden_animation_timer: Timer

## Varible to check and store current visual state
var _current_visual_state: String = "defualt_visual_state"
## Variable to check before switching base animaton to not overide sudden animation.
var _is_playing_sudden_animation: bool = false
## Variable for checking if new sudden animation should override the current
var _sudden_animation_priority : int = 0
## Variable to store baseanimation to fall back to after sudden animation completed
var _queued_base_animation_state: String



func _ready() -> void:
	if not Engine.is_editor_hint():
		# Set default animation
		_play_base_animation("default_visual_state")

	
## Method for changing the visual state
func change_state(newstate: String) -> void:
	_current_visual_state = newstate
	_play_base_animation(newstate)


func get_current_visual_state() -> String:
	return _current_visual_state


## Method for playing sudden animations - damage, lvl up. Usen by
## the VisualControllerSuddenAnimation2D nodes
func play_sudden_animation(animation: String, priority: int) -> void:
	# Play the sudden animation and queue the base animation if no other is playing
	# or if new has higher priority
	if(not _is_playing_sudden_animation or priority >= _sudden_animation_priority):
		_queued_base_animation_state = _current_visual_state
		animation_player.stop()
		animation_player.play(animation)
		
		# logic for falling back to base animation
		_is_playing_sudden_animation = true
		_sudden_animation_priority = priority
		sudden_animation_timer.wait_time = animation_player.current_animation_length
		sudden_animation_timer.start()


## Internally used method for switching base animations - idle, walk, charge
func _play_base_animation(new_state: String) -> void:
	if not _is_playing_sudden_animation:
		_update_animation_from_visual_state(new_state)
	else:
		_queued_base_animation_state = new_state


## Called when the sudden animation is finished
func _on_finished_sudden_animation():
	_is_playing_sudden_animation = false
	_play_base_animation(_queued_base_animation_state)
	
## Method for flipping the sprite. Standard is facing right
func flip_sprite(_bool : bool):
	sprite2d.flip_h = _bool


## Update the animation from a visual state
func _update_animation_from_visual_state(visual_state: String):
	animation_player.play(animation_dictionary[visual_state])
	_current_visual_state = visual_state

