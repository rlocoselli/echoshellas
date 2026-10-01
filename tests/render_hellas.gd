extends SceneTree

func _init():
	call_deferred("render")

func render():
	set_screen_stretch(SceneTree.STRETCH_MODE_2D, SceneTree.STRETCH_ASPECT_IGNORE, Vector2(384, 448))
	OS.window_size = Vector2(768, 896)
	get_root().set_size_override(true, Vector2(384, 448))
	get_root().set_size_override_stretch(true)
	var map = load("res://maps/shrine.tmx").instance()
	preload("res://tiled/hellas/environment.gd").apply(map, "delphi")
	var canvas = Node2D.new()
	canvas.position = Vector2(-128, -192)
	get_root().add_child(canvas)
	for node in map.get_children():
		if node is TileMap:
			map.remove_child(node)
			node.set_script(null)
			canvas.add_child(node)
	map.free()
	yield(self, "idle_frame")
	yield(self, "idle_frame")
	var image = get_root().get_texture().get_data()
	image.flip_y()
	image.save_png("/tmp/hellas-shrine-preview.png")
	quit()
