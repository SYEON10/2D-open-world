extends SceneTree

const ACTIONS := {
	"move_left": KEY_A,
	"move_right": KEY_D,
	"move_forward": KEY_W,
	"move_back": KEY_S,
}


func _initialize() -> void:
	for action_name: String in ACTIONS:
		var key_event := InputEventKey.new()
		key_event.physical_keycode = ACTIONS[action_name]
		ProjectSettings.set_setting(
			"input/" + action_name,
			{"deadzone": 0.2, "events": [key_event]}
		)
	ProjectSettings.save()
	print("Configured WASD input actions")
	quit()
