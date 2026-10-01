extends Panel

signal closed

const HERO_ART = preload("res://ui/hellas/odyssey.png")
const REALM_ART = preload("res://ui/hellas/realms.png")
const ENEMY_ART = preload("res://ui/hellas/bestiary.png")
var campaign = {}
var category = "heroes"
var selected = 0
var heading: Label
var picture: TextureRect
var description: RichTextLabel
var counter: Label
var tabs = []
var close_button: Button
var previous_focus

func _ready():
	name = "HellasGuide"
	var guide_font = DynamicFont.new()
	guide_font.font_data = preload("res://ui/hellas/DejaVuSans.ttf")
	guide_font.size = 12
	var guide_theme = Theme.new()
	guide_theme.default_font = guide_font
	theme = guide_theme
	rect_position = Vector2(12, 12)
	rect_size = Vector2(488, 264)
	var style = StyleBoxFlat.new()
	style.bg_color = Color("102630")
	style.border_color = Color("c9a65d")
	style.set_border_width_all(1)
	add_stylebox_override("panel", style)
	var file = File.new()
	if file.open("res://content/hellas_campaign.json", File.READ) == OK:
		campaign = parse_json(file.get_as_text())
		file.close()
	for i in range(3):
		var button = make_button(["Héros", "Bestiaire", "Scénarios"][i], Rect2(10 + i * 110, 8, 106, 24))
		button.connect("pressed", self, "choose_category", [["heroes", "enemies", "scenarios"][i]])
		tabs.append(button)
	close_button = make_button("Fermer", Rect2(386, 8, 92, 24))
	close_button.connect("pressed", self, "close")
	heading = Label.new()
	heading.rect_position = Vector2(12, 40)
	heading.rect_size = Vector2(464, 24)
	heading.add_color_override("font_color", Color("edd79f"))
	add_child(heading)
	picture = TextureRect.new()
	picture.rect_position = Vector2(12, 72)
	picture.rect_size = Vector2(198, 146)
	picture.expand = true
	picture.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
	add_child(picture)
	description = RichTextLabel.new()
	description.rect_position = Vector2(222, 72)
	description.rect_size = Vector2(252, 150)
	description.bbcode_enabled = false
	description.focus_mode = Control.FOCUS_ALL
	add_child(description)
	make_button("<", Rect2(12, 232, 42, 22)).connect("pressed", self, "turn_page", [-1])
	make_button(">", Rect2(432, 232, 42, 22)).connect("pressed", self, "turn_page", [1])
	counter = Label.new()
	counter.rect_position = Vector2(66, 232)
	counter.rect_size = Vector2(354, 22)
	counter.align = Label.ALIGN_CENTER
	add_child(counter)
	hide()

func make_button(text, bounds):
	var button = Button.new()
	button.text = text
	button.rect_position = bounds.position
	button.rect_size = bounds.size
	add_child(button)
	return button

func open():
	previous_focus = get_focus_owner()
	show()
	raise()
	choose_category("heroes")
	close_button.grab_focus()

func close():
	hide()
	emit_signal("closed")
	if is_instance_valid(previous_focus):
		previous_focus.grab_focus()

func _input(event):
	if visible and event.is_action_pressed("ui_cancel"):
		close()
		get_tree().set_input_as_handled()

func choose_category(value):
	category = value
	selected = 0
	for i in range(tabs.size()):
		tabs[i].disabled = category == ["heroes", "enemies", "scenarios"][i]
	render_page()

func turn_page(direction):
	selected = wrapi(selected + direction, 0, campaign[category].size())
	render_page()

func render_page():
	var entries = campaign.get(category, [])
	if entries.empty():
		return
	var entry = entries[selected]
	picture.texture = HERO_ART
	match category:
		"heroes":
			var portrait = AtlasTexture.new()
			portrait.atlas = HERO_ART
			var crops = [Rect2(170, 245, 520, 700), Rect2(650, 340, 350, 640), Rect2(970, 350, 540, 660)]
			portrait.region = crops[selected]
			picture.texture = portrait
			heading.text = entry.id + " — " + entry.role
			description.text = entry.description + "\n\nInspiration: " + entry.inspiration + "\n\nAll three heroes share the same equipment system."
		"enemies":
			heading.text = entry.name
			var atlas = AtlasTexture.new()
			atlas.atlas = ENEMY_ART
			var r = entry.art_region
			atlas.region = Rect2(r[0], r[1], r[2], r[3])
			picture.texture = atlas
			description.text = entry.status + "\n\n" + entry.description + "\n\n" + entry.tactic + "\n\n" + entry.origin
		"scenarios":
			var realm = AtlasTexture.new()
			realm.atlas = REALM_ART
			realm.region = Rect2((selected % 2) * 768, int(selected / 2) * 512, 768, 512)
			picture.texture = realm
			heading.text = entry.title
			description.text = entry.status + "\n\n" + entry.setting + "\n\n" + entry.objective + "\n\n"
			for i in range(entry.steps.size()):
				description.text += str(i + 1) + ". " + entry.steps[i] + "\n"
			description.text += "\nMyth: " + entry.myth + "\nReward: " + entry.reward
	description.scroll_to_line(0)
	counter.text = "%d / %d  ·  Scroll to read more" % [selected + 1, entries.size()]
