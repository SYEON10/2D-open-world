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


func _physics_process(delta: float) -> void:
	if settings == null:
		return
	var input_vector := Input.get_vector("move_left", "move_right", "move_forward", "move_back")
	velocity.x = input_vector.x * settings.movement_speed
	velocity.z = input_vector.y * settings.movement_speed
	if not is_on_floor():
		velocity += get_gravity() * delta
	move_and_slide()
