extends Reference

const PALETTE = preload("res://tiled/hellas/stone_palette.shader")
const THEMES = {
	"delphi": [Color("354d50"), Color("f0dfb5"), 0.88],
	"olive": [Color("444e3b"), Color("d0ba8f"), 0.42],
	"aegean": [Color("435f65"), Color("f4e1b9"), 0.72],
	"knossos": [Color("423e48"), Color("c18a63"), 0.65]
}

static func apply(map, theme_name):
	if not THEMES.has(theme_name):
		return
	var colors = THEMES[theme_name]
	var material = ShaderMaterial.new()
	material.shader = PALETTE
	material.set_shader_param("shadow_color", colors[0])
	material.set_shader_param("stone_color", colors[1])
	material.set_shader_param("strength", colors[2])
	for node in map.get_children():
		if node is TileMap and node.name == "walls":
			node.material = material
		if node is TileMap and theme_name == "delphi" and node.name == "decor":
			node.material = material

		if node is TileMap and theme_name == "delphi" and node.name == "floor":
			# Palette only the legacy border tiles, leaving the new teal mosaics intact.
			node.tile_set = node.tile_set.duplicate()
			for id in node.tile_set.get_tiles_ids():
				var texture = node.tile_set.tile_get_texture(id)
				if texture and "dungeon_tileset" in texture.resource_path:
					node.tile_set.tile_set_material(id, material)

		if node is TileMap and theme_name == "delphi" and "water" in node.name.to_lower():
			var water_material = ShaderMaterial.new()
			water_material.shader = PALETTE
			water_material.set_shader_param("shadow_color", Color("153c4d"))
			water_material.set_shader_param("stone_color", Color("83c6bb"))
			water_material.set_shader_param("strength", 0.94)
			node.material = water_material

	preload("res://tiled/hellas/props.gd").apply(map, theme_name)
