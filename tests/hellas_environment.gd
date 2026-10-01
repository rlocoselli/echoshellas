extends SceneTree

func _init():
	var failures = 0
	for map_name in ["shrine", "overworld", "shoreside", "dungeon1"]:
		var scene = load("res://maps/" + map_name + ".tmx")
		if scene == null:
			printerr("Cannot load ", map_name)
			failures += 1
			continue
		var map = scene.instance()
		if map.environment_theme.empty():
			printerr("Missing environment theme: ", map_name)
			failures += 1
		var original_shapes = {}
		for node in map.get_children():
			if node is TileMap:
				original_shapes[node.name] = {}
				for id in node.tile_set.get_tiles_ids():
					original_shapes[node.name][id] = collision_signature(node.tile_set.tile_get_shapes(id))
		preload("res://tiled/hellas/environment.gd").apply(map, map.environment_theme)
		if map.get_meta("greek_prop_tiles") <= 0:
			printerr("Missing Greek props in ", map_name)
			failures += 1
		var count = 0
		for node in map.get_children():
			if not node is TileMap:
				continue
			for cell in node.get_used_cells():
				var id = node.get_cellv(cell)
				var texture = node.tile_set.tile_get_texture(id)
				if texture and "greek_props" in texture.resource_path:
					if collision_signature(node.tile_set.tile_get_shapes(id)) != original_shapes[node.name][id]:
						printerr("Prop collision changed: ", map_name, "/", node.name)
						failures += 1
					if not Rect2(Vector2.ZERO, texture.get_size()).encloses(node.tile_set.tile_get_region(id)):
						printerr("Prop art outside atlas: ", map_name)
						failures += 1
				if texture and "hellas_tiles" in texture.resource_path:
					count += 1
					if not node.tile_set.tile_get_shapes(id).empty():
						failures += 1
		if count == 0:
			printerr("No new paving in ", map_name)
			failures += 1
		print(map_name, ": ", count, " Greek pixel tiles, ", map.get_meta("greek_prop_tiles"), " architectural / vegetation tiles")
		map.free()
	quit(0 if failures == 0 else 1)

func collision_signature(shapes):
	var result = []
	for entry in shapes:
		var data = entry.duplicate()
		var shape = entry.shape
		if shape is ConvexPolygonShape2D:
			data.shape = shape.points
		elif shape is RectangleShape2D:
			data.shape = shape.extents
		elif shape is ConcavePolygonShape2D:
			data.shape = shape.segments
		else:
			data.shape = shape.get_rid()
		result.append(data)
	return var2str(result)
