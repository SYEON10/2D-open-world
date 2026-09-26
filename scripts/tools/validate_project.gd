extends SceneTree


func _initialize() -> void:
	var settings := load("res://data/definitions/cube_settings.tres") as CubeSettings
	if settings == null or settings.movement_speed <= 0.0:
		printerr("Cube settings could not be loaded")
		quit(1)
		return
	var cube_scene := load("res://scenes/actors/cube_actor.tscn") as PackedScene
	if cube_scene == null:
		printerr("Cube scene could not be loaded")
		quit(1)
		return
	print("Project data validated")
	quit()
