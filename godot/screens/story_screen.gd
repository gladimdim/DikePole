class_name StoryScreen
extends Control
## Story page of the thin design: full-bleed cover (the list thumbnail flies into
## it), year and language, title, author, length / choices / endings, the
## description, which endings the reader has found, and Read / Continue / Start over.

const SIDE := 24

var entry: Dictionary

var _root: Control


static func create(catalog_entry: Dictionary) -> StoryScreen:
	var screen := StoryScreen.new()
	screen.entry = catalog_entry
	return screen


func _ready() -> void:
	var background := PanelContainer.new()
	background.theme_type_variation = &"Paper"
	background.mouse_filter = Control.MOUSE_FILTER_IGNORE
	add_child(UI.fill_parent(background))
	_build()
	AppTheme.changed.connect(_rebuild)


func _notification(what: int) -> void:
	if what == NOTIFICATION_TRANSLATION_CHANGED and is_node_ready():
		_rebuild.call_deferred()


## Back from reading: progress and endings may have changed.
func on_revealed() -> void:
	_rebuild()


func _rebuild() -> void:
	if _root:
		_root.queue_free()
	_build()


func _build() -> void:
	var stats := StoryLibrary.stats(entry)
	var progress := StoryLibrary.progress(entry)
	var width := get_viewport_rect().size.x

	var cover := StoryImage.from_spec(BackgroundImages.cover_spec(entry, true))
	cover.fit = StoryImage.Fit.COVER
	cover.custom_minimum_size.y = roundf(width * 0.75)
	cover.hero_tag = "story:" + StoryLibrary.story_id(entry)
	cover.motion_duration = 20.0

	var caps := "%s  ·  %s" % [entry["year"], tr("story_in_" + str(stats["language"])).to_upper()]
	var title := UI.label(entry["title"], &"Display", false)
	title.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	var author := UI.label(entry["author"], &"Meta", false)
	author.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	var description := UI.label(entry["description"], &"Body", false)
	description.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART

	var details := UI.vbox([
		UI.label(caps, &"Caps", false), UI.spacer(0, 8), title, UI.spacer(0, 6), author,
		UI.spacer(0, 24), _stats_row(stats), UI.spacer(0, 24), description,
		UI.spacer(0, 30), _endings(stats, progress),
	])
	details.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	var column := UI.vbox([cover, UI.margin(details, SIDE, 22, SIDE, 28)])
	column.size_flags_horizontal = Control.SIZE_EXPAND_FILL

	var scroll := ScrollContainer.new()
	scroll.horizontal_scroll_mode = ScrollContainer.SCROLL_MODE_DISABLED
	scroll.vertical_scroll_mode = ScrollContainer.SCROLL_MODE_SHOW_NEVER
	scroll.size_flags_vertical = Control.SIZE_EXPAND_FILL
	scroll.add_child(column)

	_root = Control.new()
	add_child(UI.fill_parent(_root))
	var page := UI.vbox([scroll, ThinWidgets.hairline(), UI.margin(_actions(progress), SIDE, 14, SIDE, 16)])
	_root.add_child(UI.fill_parent(page))
	_root.add_child(_back_button())


func _stats_row(stats: Dictionary) -> Control:
	var row := HBoxContainer.new()
	row.add_theme_constant_override("separation", 0)
	var cells := [[stats["minutes"], "stat_minutes"], [stats["choices"], "stat_choices"],
			[stats["endings"].size(), "stat_endings"]]
	for i in cells.size():
		if i > 0:
			row.add_child(ThinWidgets.hairline(true))
		var number := UI.label(str(cells[i][0]), &"Stat", false)
		number.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
		var label := UI.label(cells[i][1], &"Meta")
		label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
		var cell := UI.vbox([number, label], 2)
		cell.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		row.add_child(cell)
	return UI.vbox([ThinWidgets.hairline(), UI.margin(row, 0, 14, 0, 14), ThinWidgets.hairline()])


## Found endings first, then one "not found yet" line per remaining ending, so the
## list shows how much is left without telling which choices lead there.
func _endings(stats: Dictionary, progress: Dictionary) -> Control:
	var found: Dictionary = progress["found"]
	var total: int = stats["endings"].size()
	var heading := HBoxContainer.new()
	heading.add_theme_constant_override("separation", 8)
	heading.add_child(UI.label("endings_title", &"H2"))
	var count := UI.label("%d / %d" % [found.size(), total], &"Meta", false)
	count.size_flags_vertical = Control.SIZE_SHRINK_END
	heading.add_child(UI.margin(count, 0, 0, 0, 3))
	var list := UI.vbox([heading, UI.spacer(0, 8)], 0)
	var kinds := found.values()
	kinds.sort()
	for kind in kinds:
		list.add_child(_ending_line(kind, true))
	for i in maxi(0, total - found.size()):
		list.add_child(_ending_line("", false))
	return list


func _ending_line(kind: String, found: bool) -> Control:
	var key := "ending_hidden"
	match kind:
		"ALIVE":
			key = "ending_alive"
		"DEAD":
			key = "ending_dead"
		"OPEN":
			key = "ending_open"
	var icon := LineIcon.create(LineIcon.Kind.FLAG, 18, AppTheme.accent if found else AppTheme.hairline)
	var label := UI.label(key, &"Body")
	if not found:
		label.add_theme_color_override("font_color", AppTheme.ink_soft)
	var row := HBoxContainer.new()
	row.add_theme_constant_override("separation", 12)
	row.add_child(icon)
	row.add_child(label)
	return UI.vbox([UI.margin(row, 0, 10, 0, 10), ThinWidgets.hairline()])


func _actions(progress: Dictionary) -> Control:
	match progress["status"]:
		StoryLibrary.Status.READING:
			var go_on := ThinWidgets.primary_button(tr("story_continue") % progress["percent"],
					ReaderScreen.open.bind(entry, false, Router.Transition.PLATFORM), false)
			var restart := ThinWidgets.quiet_button("story_restart",
					ReaderScreen.open.bind(entry, true, Router.Transition.PLATFORM))
			return UI.vbox([go_on, restart], 10)
		StoryLibrary.Status.FINISHED:
			return ThinWidgets.primary_button("story_restart", ReaderScreen.open.bind(entry, true, Router.Transition.PLATFORM))
	return ThinWidgets.primary_button("startstory", ReaderScreen.open.bind(entry, false, Router.Transition.PLATFORM))


## Round translucent back button over the cover.
func _back_button() -> Control:
	var circle := PanelContainer.new()
	circle.add_theme_stylebox_override("panel", AppTheme.flat(Color(0, 0, 0, 0.38), 20))
	circle.custom_minimum_size = Vector2(40, 40)
	var icon := LineIcon.create(LineIcon.Kind.CHEVRON_LEFT, 22, Color.WHITE)
	icon.size_flags_horizontal = Control.SIZE_SHRINK_CENTER
	icon.size_flags_vertical = Control.SIZE_SHRINK_CENTER
	circle.add_child(icon)
	var button := Pressable.wrap(circle, func() -> void: Router.instance.pop())
	button.position = Vector2(14, 14)
	button.size = Vector2(40, 40)
	return button
