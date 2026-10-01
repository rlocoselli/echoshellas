extends Reference

const ART = preload("res://tiled/hellas/greek_props.png")

# Replace only texture regions. Original tile IDs, collision shapes, offsets,
# navigation and map positions remain intact.
static func apply(map, theme_name):
	var used = 0
	for node in map.get_children():
		if not node is TileMap or not node.tile_set:
			continue
		node.tile_set = node.tile_set.duplicate()
		var changed = []
		for id in node.tile_set.get_tiles_ids():
			var texture = node.tile_set.tile_get_texture(id)
			if not texture:
				continue
			var source = texture.resource_path
			var old = node.tile_set.tile_get_region(id)
			if old.size != Vector2(16, 16):
				continue
			var index = int(old.position.y / 16) * 5 + int(old.position.x / 16)
			var region = Vector2(-1, -1)
			if "dungeon_tileset.png" in source and theme_name == "delphi":
				var pieces = {
					220: Vector2(0, 0), 221: Vector2(16, 0), 225: Vector2(0, 16), 226: Vector2(16, 16),
					222: Vector2(32, 0), 223: Vector2(48, 0), 227: Vector2(32, 16), 228: Vector2(48, 16),
					232: Vector2(32, 0), 233: Vector2(48, 0), 237: Vector2(32, 16), 238: Vector2(48, 16),
					230: Vector2(0, 32), 231: Vector2(16, 32), 235: Vector2(0, 48), 236: Vector2(16, 48),
					247: Vector2(32, 32), 248: Vector2(48, 32),
					267: Vector2(112, 0), 269: Vector2(112, 0)
				}
				region = pieces.get(index, region)
			if "overworld_tileset.png" in source and theme_name in ["olive", "aegean"]:
				region = {120: Vector2(64, 0), 121: Vector2(80, 0), 125: Vector2(64, 16), 126: Vector2(80, 16)}.get(index, region)
			if "beach_tileset.png" in source and theme_name == "aegean":
				region = {190: Vector2(64, 0), 191: Vector2(80, 0), 195: Vector2(64, 16), 196: Vector2(80, 16)}.get(index, region)
			if "dungeon1_tileset.png" in source and theme_name == "knossos":
				region = {23: Vector2(96, 0), 28: Vector2(96, 16), 33: Vector2(96, 32)}.get(index, region)
			if region.x >= 0:
				node.tile_set.tile_set_texture(id, ART)
				node.tile_set.tile_set_region(id, Rect2(region, Vector2(16, 16)))
				node.tile_set.tile_set_material(id, null)
				changed.append(id)
		for cell in node.get_used_cells():
			if node.get_cellv(cell) in changed:
				used += 1
	map.set_meta("greek_prop_tiles", used)
