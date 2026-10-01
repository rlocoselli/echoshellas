extends SceneTree

var failures = []

func check(value, message):
	if not value:
		failures.append(message)
		printerr("FAIL: ", message)

func _init():
	call_deferred("run")

func run():
	var guide = load("res://ui/hellas/guide.gd").new()
	get_root().add_child(guide)
	guide.open()
	check(guide.visible, "guide opens")
	for category in ["heroes", "enemies", "scenarios"]:
		guide.choose_category(category)
		var count = guide.campaign[category].size()
		for i in range(count):
			check(not guide.heading.text.empty(), "page title")
			check(guide.description.text.length() > 40, "page description")
			check(guide.picture.texture != null, "page artwork")
			var art = guide.picture.texture
			if art is AtlasTexture:
				check(Rect2(Vector2.ZERO, art.atlas.get_size()).encloses(art.region), "art crop within source")
			guide.turn_page(1)
		check(guide.selected == 0, "page navigation wraps")
		guide.turn_page(-1)
		check(guide.selected == count - 1, "previous page wraps")
	guide.close()
	check(not guide.visible, "guide closes")
	guide.free()
	var enemy = load("res://entities/enemies/stalfos/stalfos.tscn").instance()
	var sprite = enemy.get_node("Sprite")
	check(sprite is Sprite, "enemy uses the same pixel sprite renderer as other enemies")
	check(sprite.hframes == 5, "all five enemy poses exist")
	check(sprite.texture.get_size() / Vector2(sprite.hframes, sprite.vframes) == Vector2(16, 16), "enemy uses 16-pixel frames")
	check(sprite.scale == Vector2.ONE and sprite.offset == Vector2.ZERO, "enemy retains the original scale and alignment")
	for name in ["animate", "unanimate", "walk", "throw"]:
		check(enemy.get_node("AnimationPlayer").has_animation(name), "enemy animation retained: " + name)
	enemy.free()
	if failures.empty():
		print("Hellas guide OK: 11 pages, navigation, art crops, five enemy poses")
	quit(0 if failures.empty() else 1)
