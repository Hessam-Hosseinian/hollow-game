class_name InputSetup
extends RefCounted

static func install() -> void:
	var mapping := {"move_left": [KEY_A, KEY_LEFT], "move_right": [KEY_D, KEY_RIGHT],
		"jump": [KEY_SPACE], "attack": [KEY_J], "special": [KEY_K],
		"dodge": [KEY_L, KEY_SHIFT], "interact": [KEY_E], "pause": [KEY_ESCAPE],
		"form_0": [KEY_1], "form_1": [KEY_2], "form_2": [KEY_3], "form_3": [KEY_4]}
	for action in mapping:
		if not InputMap.has_action(action):
			InputMap.add_action(action)
		for key in mapping[action]:
			var event := InputEventKey.new()
			event.physical_keycode = key
			if not InputMap.action_has_event(action, event):
				InputMap.action_add_event(action, event)
