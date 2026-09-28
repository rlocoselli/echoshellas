extends SceneTree

var failures = []

func check(value, message):
	if not value:
		failures.append(message)
		printerr("FAIL: ", message)

func _init():
	call_deferred("run")

func run():
	var main_resource = load("res://engine/main.tscn")
	check(main_resource != null, "main menu scene loads")
	if main_resource != null:
		var main = main_resource.instance()
		check(main.has_node("intro/Title"), "prologue title exists")
		check(main.has_node("intro/Story"), "prologue story exists")
		check(main.has_node("intro/Progress"), "prologue progress exists")
		check(main.has_node("intro/Continue"), "prologue continue exists")
		check(main.has_node("intro/Skip"), "prologue skip exists")
		check(main.get_node("bg").texture != null, "high-resolution menu art loads")
		main.free()

	var hero_resource = load("res://ui/options/character.tscn")
	check(hero_resource != null, "character selector loads")
	if hero_resource != null:
		var hero_menu = hero_resource.instance()
		check(hero_menu.get_node("HeroLineup").texture != null, "hero illustration loads")
		hero_menu.free()

	var player_resource = load("res://entities/player/player.tscn")
	check(player_resource != null, "player scene loads")
	if player_resource != null:
		var player = player_resource.instance()
		check(player.has_node("GroundShadow"), "player has a grounded shadow")
		player.free()

	var hud_resource = load("res://ui/hud/hud.tscn")
	check(hud_resource != null, "HUD scene loads")
	if hud_resource != null:
		var hud = hud_resource.instance()
		check(hud.has_node("StatusBackdrop"), "HUD status panel exists")
		check(not hud.has_node("HellasFrame"), "HUD no longer obstructs the game view")
		hud.free()

	var file = File.new()
	check(file.open("res://content/prologue.json", File.READ) == OK, "prologue data opens")
	if file.is_open():
		var story = parse_json(file.get_as_text())
		check(typeof(story) == TYPE_DICTIONARY and story.has("pages") and story.pages.size() >= 3, "prologue data parses")
		file.close()

	if failures.empty():
		print("Godot smoke OK: scenes, artwork, HUD and prologue")
		quit(0)
	else:
		quit(1)
