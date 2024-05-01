class_name StateMachineController extends Node
## A class for isolating all needed process input and such to the statemachine
## Really just an abstaction to isolate the statemachine from the process functions


var state_machine: StateMachine


func _ready() -> void:
	# Initialize the state machine, passing a reference of the player to the states,
	# that way they can move and react accordingly
	_get_state_machine()
	state_machine.init(self)


func _unhandled_input(event: InputEvent) -> void:
	state_machine.state_unhandled_input(event)


func _physics_process(delta: float) -> void:
	state_machine.state_physics_process(delta)


func _process(delta: float) -> void:
	state_machine.state_process(delta)


func _get_state_machine():
	for child in get_children():
		if child is StateMachine:
			state_machine = child
