class_name StoryRow
extends HBoxContainer
## One story in the home list: a timeline rail (the dot shows new / reading /
## finished), the cover thumbnail, year, title and what the reader may want to know
## before opening it (length, endings found, progress).

signal opened(entry: Dictionary)

const THUMB_SIZE := Vector2(84, 63)
const RAIL_WIDTH := 22.0

var entry: Dictionary
var first := false
var last := false

var _rail: Rail
var _thumb: StoryImage


func _ready() -> void:
	add_theme_constant_override("separation", 0)
	var stats := StoryLibrary.stats(entry)
	var progress := StoryLibrary.progress(entry)

	_rail = Rail.new()
	_rail.first = first
	_rail.last = last
	_rail.status = progress["status"]
	add_child(_rail)

	_thumb = StoryImage.from_spec(BackgroundImages.cover_spec(entry))
	_thumb.fit = StoryImage.Fit.COVER
	_thumb.corner_radius = 1.0
	_thumb.custom_minimum_size = THUMB_SIZE
	_thumb.size_flags_vertical = Control.SIZE_SHRINK_CENTER
	_thumb.hero_tag = "story:" + StoryLibrary.story_id(entry)

	var year := str(entry["year"])
	if stats["language"] == "en":
		year += "  ·  EN"
	var title := UI.label(entry["title"], &"Title", false)
	title.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	title.max_lines_visible = 2
	var meta := UI.label("%s   ·   %s" % [tr("meta_minutes") % stats["minutes"],
			tr("meta_endings") % [progress["found"].size(), stats["endings"].size()]], &"Meta", false)
	var text := UI.vbox([UI.label(year, &"Caps", false), title, meta], 3)
	text.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	text.size_flags_vertical = Control.SIZE_SHRINK_CENTER
	match progress["status"]:
		StoryLibrary.Status.READING:
			var line := ThinWidgets.progress_line(progress["percent"])
			line.size_flags_vertical = Control.SIZE_SHRINK_CENTER
			line.size_flags_horizontal = Control.SIZE_EXPAND_FILL
			var row := HBoxContainer.new()
			row.add_theme_constant_override("separation", 10)
			row.add_child(line)
			row.add_child(UI.label("%d%%" % progress["percent"], &"Meta", false))
			text.add_child(UI.margin(row, 0, 4))
		StoryLibrary.Status.FINISHED:
			var done := HBoxContainer.new()
			done.add_theme_constant_override("separation", 4)
			done.add_child(LineIcon.create(LineIcon.Kind.CHECK, 16, AppTheme.accent))
			var label := UI.label("status_finished", &"Meta")
			label.add_theme_color_override("font_color", AppTheme.accent)
			done.add_child(label)
			text.add_child(done)

	var content := HBoxContainer.new()
	content.add_theme_constant_override("separation", 16)
	content.add_child(_thumb)
	content.add_child(text)
	var body := UI.vbox([UI.margin(content, 0, 14, 0, 14), ThinWidgets.hairline()])
	body.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	var tap := Pressable.wrap(body, func() -> void: opened.emit(entry))
	tap.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	add_child(tap)


## The vertical timeline: a hairline through all rows and a dot per story:
## outlined = new, ring with a center = reading, filled = finished.
class Rail:
	extends Control
	var first := false
	var last := false
	var status := StoryLibrary.Status.NEW

	func _init() -> void:
		custom_minimum_size.x = RAIL_WIDTH
		mouse_filter = Control.MOUSE_FILTER_IGNORE

	func _draw() -> void:
		var x := 5.0
		var y := size.y / 2.0
		var top := y if first else 0.0
		var bottom := y if last else size.y
		draw_line(Vector2(x, top), Vector2(x, bottom), AppTheme.hairline, 1.0)
		match status:
			StoryLibrary.Status.NEW:
				draw_circle(Vector2(x, y), 4.5, AppTheme.paper, true, -1.0, true)
				draw_arc(Vector2(x, y), 4.0, 0, TAU, 24, AppTheme.ink_soft, 1.0, true)
			StoryLibrary.Status.READING:
				draw_circle(Vector2(x, y), 5.0, AppTheme.paper, true, -1.0, true)
				draw_arc(Vector2(x, y), 4.5, 0, TAU, 24, AppTheme.accent, 1.2, true)
				draw_circle(Vector2(x, y), 2.0, AppTheme.accent, true, -1.0, true)
			StoryLibrary.Status.FINISHED:
				draw_circle(Vector2(x, y), 4.5, AppTheme.accent, true, -1.0, true)
