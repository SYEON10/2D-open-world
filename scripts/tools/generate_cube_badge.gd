extends SceneTree

const OUTPUT_PATH := "res://assets/generated/cube_badge.svg"
const SVG := """<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 128 128">
  <rect width="128" height="128" rx="24" fill="#2b5b83"/>
  <path d="M64 20 104 42 64 64 24 42Z" fill="#8bd3ff"/>
  <path d="M24 42 64 64 64 108 24 86Z" fill="#3c91d4"/>
  <path d="M104 42 64 64 64 108 104 86Z" fill="#155f9e"/>
</svg>
"""


func _initialize() -> void:
	DirAccess.make_dir_recursive_absolute(ProjectSettings.globalize_path("res://assets/generated"))
	var file := FileAccess.open(OUTPUT_PATH, FileAccess.WRITE)
	if file == null:
		printerr("Failed to write: ", OUTPUT_PATH)
		quit(1)
		return
	file.store_string(SVG)
	file.close()
	print("Generated ", OUTPUT_PATH)
	quit()
