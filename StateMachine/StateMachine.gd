class_name StateMachine extends Node

@export
var starting_state: State

var current_state: State

var parent: Node

# Initialize the state machine by giving each child state a reference to the
# parent object it belongs to and enter the default starting_state.
func init(_parent: Node) -> void:
	
	parent = _parent
	
	for child in get_children():
		if child is State:
			child.parent = parent

	
	# Initialize to the default state
	change_state(starting_state)


# Change to the new state by first calling any exit logic on the current state.
func change_state(new_state: State) -> void:
	if current_state:
		current_state.exit()

	current_state = new_state
	current_state.enter()

# handling state changes as needed.

func state_process(delta: float) -> void:
	var new_state = current_state.state_process(delta)
	if new_state:
		change_state(new_state)


func state_physics_process(delta: float) -> void:
	var new_state = current_state.state_physics_process(delta)
	if new_state:
		change_state(new_state)


func state_unhandled_input(event: InputEvent) -> void:
	var new_state = current_state.state_undhandled_input(event)
	if new_state:
		change_state(new_state)
