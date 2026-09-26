extends SceneTree

const OUTPUT_PATH := "res://assets/generated/cube_checker.res"
const IMAGE_SIZE := 16


func _initialize() -> void:
	var image := Image.create(IMAGE_SIZE, IMAGE_SIZE, false, Image.FORMAT_RGBA8)
	for y in range(IMAGE_SIZE):
		for x in range(IMAGE_SIZE):
			var color := Color("#8bd3ff") if (x / 4 + y / 4) % 2 == 0 else Color("#155f9e")
			image.set_pixel(x, y, color)
	var texture := ImageTexture.create_from_image(image)
	var error := ResourceSaver.save(texture, OUTPUT_PATH)
	if error != OK:
		printerr("Failed to save binary texture: ", error)
		quit(1)
		return
	print("Generated ", OUTPUT_PATH)
	quit()
