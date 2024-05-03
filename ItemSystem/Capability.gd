class_name Capability
extends Node
## A superclass for item capabilities for the item system
## The capability should give the item ONE capability I.E Heal on usag

@export var id: int = 0
@export var capability_description: String = ""

## Applied immidiately/on pickup. Virtual function override in class extension
func apply_passive_effect():
	pass

func remove_passive_effect():
	pass

## Applied on activation. Virtual function override in class extension
func  apply_active_effect():
	pass
