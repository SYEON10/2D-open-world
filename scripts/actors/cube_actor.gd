class_name CubeActor
extends CharacterBody3D

@export var settings: CubeSettings

@onready var _mesh_instance: MeshInstance3D = $MeshInstance3D


func _ready() -> void:
	if settings == null:
		push_error("CubeActor requires CubeSettings")
		return
	var material := StandardMaterial3D.new()
	material.albedo_color = settings.body_color
	_mesh_instance.material_override = material
