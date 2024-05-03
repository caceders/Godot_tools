class_name Targetable extends Node

## Used in combination with TargetSelector to be able to take a target from an
## array and perform something on it.
## All Nodes with a target node will be able to interact with TargetSelectors

signal was_targeted(target_selector: TargetSelector)
signal was_detargeted(target_selector: TargetSelector)

## Array of target selectors that conatin this object
var in_target_selectors: Array[TargetSelector] = []
var highlight : bool = false


func _exit_tree():
	# Remove the target from its selectors when removed from the scene
	if not in_target_selectors.is_empty():
		# Remove from array in reverse order to not get indexing error
		# in the reverse call
		for i in range(in_target_selectors.size() - 1, -1 ,-1):
			in_target_selectors[i].remove_from_selection(self)
			# Popping of target selector is handled by the selecor


## Called by target selectors when target gets added to a selection
func add_to_selection(taget_selector: TargetSelector):
	in_target_selectors.append(taget_selector)



## Called by target selectors when target is removed from a selection
func remove_from_selection(taget_selector: TargetSelector):
	in_target_selectors.erase(taget_selector)
