@tool
extends Label

var ControllerDisplayString : String = ""

func _process(delta):
	ControllerDisplayString = ""
	var actions = InputMap.get_actions()
	for action in actions:
		if not action.contains("ui") or action.contains("spatial") :
			var actionEvents = InputMap.action_get_events(action)
			if not actionEvents.is_empty():
				ControllerDisplayString += (action + ": ")
				for actionEvent in actionEvents:
					ControllerDisplayString += (actionEvent.as_text() + " ")
				ControllerDisplayString = ControllerDisplayString.erase(ControllerDisplayString.length() - 1)
				ControllerDisplayString += "          "
	
	ControllerDisplayString =ControllerDisplayString.replacen("(Physical)", "")
	text = ControllerDisplayString
