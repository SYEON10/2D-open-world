extends SceneTree


func _initialize() -> void:
	call_deferred("_verify")


func _verify() -> void:
	var playground := load("res://scenes/levels/cube_playground.tscn") as PackedScene
	if playground == null:
		printerr("Playground could not be loaded")
		quit(1)
		return
	var level := playground.instantiate()
	root.add_child(level)
	var cube := level.get_node("CubeActor") as CubeActor
	var start_position := cube.global_position
	Input.action_press("move_forward")
	for frame_index in range(12):
		await physics_frame
	Input.action_release("move_forward")
	if cube.global_position.z >= start_position.z - 0.2:
		printerr("W input did not move the cube forward")
		quit(1)
		return
	print("W input moved cube from ", start_position, " to ", cube.global_position)
	quit()
