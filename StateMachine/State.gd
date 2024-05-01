class_name State extends Node

var parent: Node


func enter() -> void:
	pass


func exit() -> void:
	pass


func state_process(delta: float) -> State:
	return null

''
func state_physics_process(delta: float) -> State:
	return null


func state_undhandled_input(event: InputEvent) -> State:
	return null
