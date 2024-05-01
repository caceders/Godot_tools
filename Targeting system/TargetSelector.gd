@tool
class_name TargetSelector extends Node

## Used in combination with Targetable to be able to take a target from an
## array and perform something on it.
## All Nodes with a target node will be able to interact with TargetSelectors

## The active target to perfom something on
@export var active_target: Targetable = null

## Array of possible targets
@export var targets: Array[Targetable] = []


@export var has_active_target : bool:
	get:
		return active_target != null
	set(Value):
		pass

@export var should_highlight : bool = false

## Variables used in sorting method
var _closest_to = null
var _component = null
var _subcomponent = null
var _property = null
var _subproperty = null
var _type = null


func  _ready():
	pass


func _process(delta):
	_in_editor_process(delta)


func _exit_tree():
	# Remove the targetselector from its targets when removed from the scene
	if not targets.is_empty():
		# Remove from array in reverse order to not get indexing error
		# in the reverse call
		for i in range(targets.size() - 1, -1 ,-1):
			targets[i].remove_from_selection(self)
			targets.pop_at(i)


func add_to_selection(targetable: Targetable):
	if targetable in targets:
		return
	targetable.add_to_selection(self)
	targets.append(targetable)


func remove_from_selection(targetable: Targetable):
	if targetable not in targets:
		return
	if active_target == targetable:
		remove_active_target()
	targetable.remove_from_selection(self)
	targets.erase(targetable)


func select_next_target():
	if active_target == null or targets.size() == 1:
		return
	
	# Selects next target in the array. If active target is last in array
	# select the first element instead.
	var active_target_index = targets.find(active_target)
	if active_target_index == (targets.size() -1):
		select_active_target(targets[0])
	else:
		select_active_target(targets[active_target_index + 1])


func select_previous_target():
	if active_target == null or targets.size() == 1:
		return
	
	# Selects previous target in the array. If active target is first in array
	# select the last element instead.
	var active_target_index = targets.find(active_target)
	if active_target_index == (0):
		select_active_target(targets[targets.size() - 1])
	else:
		select_active_target(targets[active_target_index])


func select_first_target():
	if targets.is_empty():
		return
	else:
		select_active_target(targets[0])


func select_last_target():
	if targets.is_empty():
		return
	else:
		select_active_target(targets[-1])

func remove_active_target():
	if not active_target:
		return
	if should_highlight:
		active_target.highlight = false
	active_target.was_detargeted.emit(self)
	active_target = null

func select_active_target(target: Targetable):
	if active_target == target:
		return
	
	if target not in targets:
		add_to_selection(target)
	
	remove_active_target()
	active_target = target
	if should_highlight:
		target.highlight = true
	active_target.was_targeted.emit(self)

## Custom sorting method. Takes a component, a component propery and a bool
## if the list should be reversed. Usually used to sort after value in
## order, but can also be used to check value closest to "closest_to"
## If the component is the parent pass "." as component.
## If accessing subcomponent use [Component/Subcomponent]
## If accessing subproperty use [Property.subproperty]
func sort_targets_by(component_path: String, property: String, is_reversed: bool = false, closest_to = null):
	
	# Set the component and property globaly for use in other sorting method
	var components = component_path.split("/")
	_component = components[-1]
	
	var property_path = property.split(".")
	if property_path.size() == 1:
		_property = property
		_subproperty = null
	else:
		_property = property_path[0]
		_subproperty = property_path[1]
	
	# Set the closest to property globaly for use in other sorting method
	_closest_to = closest_to
	
	# A type variable to bo used later. Different sort for different types
	_type = null
	
	# If no elements return
	if targets.is_empty():
		return
	
	# If only one element return
	if targets.size() == 1:
		return
		
	# Make subarray of elements containing property and elements that don't
	var targets_has_property = []
	var targets_has_not_property = []
	
	var propery_is_bool: bool = false
	
	for target in targets:
		var found_component = target
		var has_found_all_wanted_component = true
		# Check if target has the relevant components
		for component in components:
			if not found_component.get_parent().has_node(component):
				targets_has_not_property.append(target)
				has_found_all_wanted_component = false
			found_component = found_component.get_parent().get_node(component)
			
			# Progress beyond here if target had component 
		if has_found_all_wanted_component:
			# Check if component has the relevant propery
			if not _subproperty:
				# If subproperty not existing worry and worry hard
				assert(property in found_component)
				_type = typeof(found_component[property])
				propery_is_bool = (_type == TYPE_BOOL)
				targets_has_property.append(target)
			else:
				# May the lord be with you, for this is a cursed method to access
				# a subproperty
				_type = typeof(found_component[_property][_subproperty])
				propery_is_bool = _type == TYPE_BOOL
				targets_has_property.append(target)
			
			
	# If found no target with relevant propery return
	if targets_has_property.is_empty():
		return
	
	
	# Clear targets array for appending sorted array of targets with propery and
	# then append array of targets without propery
	targets.clear()
	
	# If found only one with relevant propery, place first. Also if the propery
	# type is bool don't sort the has_propery array.
	if targets_has_property.size() == 1 or propery_is_bool:
		targets.append_array(targets_has_property)
		targets.append_array(targets_has_not_property)
		return
	

	targets_has_property.sort_custom(_sort_ascending)
	if is_reversed:
		targets_has_property.reverse()
	targets.append_array(targets_has_property)
	targets.append_array(targets_has_not_property)


func _sort_ascending(a: Targetable, b: Targetable):
	
	# Set the relevant components and properties from a and b
	var a_component = a.get_parent().get_node(_component)
	var a_property = a_component[_property]
	var b_component = b.get_parent().get_node(_component)
	var b_property = b_component[_property]
	if _subcomponent:
		a_component = a.get_parent().get_node(_component).get_node(_subcomponent)
		b_component = b.get_parent().get_node(_component).get_node(_subcomponent)
	# If subproperty just change the property to the subproperty
	if _subproperty:
		a_property = a_component[_property][_subproperty]
		b_property = b_component[_property][_subproperty]
		
	_type = typeof(a_property)
	
	# If float or int check value
	if ((_type == TYPE_FLOAT) or (_type == TYPE_INT)):
		if _closest_to:
			assert(_type == typeof(_closest_to))
			var a_distance = abs(a_property - _closest_to)
			var b_distance = abs(b_property - _closest_to)
			return a_distance < b_distance
		else:
			return a_property < b_property
	
	# If vector2 or vector3 check length
	if ((_type == TYPE_VECTOR2) or (_type == TYPE_VECTOR3)):
		if _closest_to:
			assert(_type == typeof(_closest_to))
			var a_distance = (a_property - _closest_to).length()
			var b_distance = (b_property - _closest_to).length()
			return a_distance < b_distance
		else:
			return a_property.length() < b_property.length()
	
	# If a string sort alphabetically or with the ones with the substring first
	if ((_type == TYPE_STRING) or (_type == TYPE_STRING_NAME)):	
		if _closest_to:
			return _closest_to.contains(b_property) or b_property.contains(_closest_to)
		else:
			var shortest_string_length = min(a_property.length(), b_property.length())
			for i in range(shortest_string_length):
				if a_property[i] > b_property[i]:
					return false
				if a_property[i] < b_property[i]:
					return true
	
	# If neither vector or number return false
	return false


func _in_editor_process(delta):
	if Engine.is_editor_hint():
		# Add active target to targets array if set in inspector
		if active_target != null:
			add_to_selection(active_target)
