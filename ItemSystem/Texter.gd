class_name Texter
extends Capability

@export var label: Label

func apply_active_effect():
	label.text = "Hello world"

func apply_passive_effect():
	label.text = "Secret things happend to those in the dark"
	
func remove_passive_effect():
	label.text = "---"
