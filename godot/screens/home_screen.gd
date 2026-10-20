class_name HomeScreen
extends Control
## Main menu and story selection of the thin design, in one screen: wordmark and
## settings, "continue reading" (or a welcome) card, filters, and the stories along
## a historical timeline.

enum Filter { ALL, NEW, READING, FINISHED }

const SIDE := 20
const COSSACK_PHOTO := "res://images/background/c_cossack_0.jpg"
const SITE_URL := "https://locadeserta.com/"

var _filter := Filter.ALL
var _scroll: ScrollContainer
var _continue_slot: VBoxContainer
var _chips: HBoxContainer
var _list: VBoxContainer
var _count: Label
var _sheet: SettingsSheet
var _root: Control


func _ready() -> void:
	var background := PaperBackground.new()
	background.mouse_filter = Control.MOUSE_FILTER_IGNORE
	add_child(UI.fill_parent(background))
	_build()
	AppTheme.changed.connect(_rebuild)


func _notification(what: int) -> void:
	if what == NOTIFICATION_TRANSLATION_CHANGED and is_node_ready():
		_rebuild.call_deferred()


## Android back closes the settings first.
func handle_back() -> bool:
	if _sheet and is_instance_valid(_sheet):
		_sheet.close()
		_sheet = null
		return true
	return false


## Back from a story: progress, endings and the continue card may have changed.
func on_revealed() -> void:
	var scroll := _scroll.scroll_vertical
	_rebuild()
	_scroll.set_deferred("scroll_vertical", scroll)


func _rebuild() -> void:
	if _root:
		_root.queue_free()
	_build(false)


func _build(animate := true) -> void:
	_root = UI.vbox()
	add_child(UI.fill_parent(_root))
	_root.add_child(_header())

	_scroll = ScrollContainer.new()
	_scroll.horizontal_scroll_mode = ScrollContainer.SCROLL_MODE_DISABLED
	_scroll.vertical_scroll_mode = ScrollContainer.SCROLL_MODE_SHOW_NEVER
	_scroll.size_flags_vertical = Control.SIZE_EXPAND_FILL
	_root.add_child(_scroll)

	_continue_slot = UI.vbox()
	_count = UI.label("", &"Meta", false)
	_count.size_flags_vertical = Control.SIZE_SHRINK_END
	var heading := HBoxContainer.new()
	heading.add_theme_constant_override("separation", 8)
	heading.add_child(UI.label("home_stories", &"H2"))
	heading.add_child(UI.margin(_count, 0, 0, 0, 3))
	_chips = HBoxContainer.new()
	_chips.add_theme_constant_override("separation", 8)
	_list = UI.vbox()

	var content := UI.vbox([_continue_slot, UI.spacer(0, 30), heading, UI.spacer(0, 14), _chips,
			UI.spacer(0, 10), _list, UI.spacer(0, 28), _footer()])
	content.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	var padded := UI.margin(content, SIDE, 4, SIDE, 24)
	padded.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	_scroll.add_child(padded)

	_continue_slot.add_child(_continue_card())
	_fill_chips()
	_fill_list(animate)


func _header() -> Control:
	var wordmark := UI.label(tr("apptitle").to_upper(), &"Wordmark", false)
	wordmark.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	wordmark.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	var gear := LineIcon.create(LineIcon.Kind.GEAR, 24)
	var gear_box := CenterContainer.new()
	gear_box.custom_minimum_size = Vector2(44, 44)
	gear_box.add_child(gear)
	var row := HBoxContainer.new()
	row.custom_minimum_size.y = 56
	row.add_child(wordmark)
	row.add_child(Pressable.wrap(gear_box, _open_settings))
	return UI.margin(row, SIDE + 2, 0, SIDE - 10, 0)


## Big card at the top: the story in progress, or a welcome that leads to the first
## unread story.
func _continue_card() -> Control:
	var entry := StoryLibrary.last_unfinished()
	var spec: Dictionary
	var caps: String
	var title: String
	var percent := -1
	if entry.is_empty():
		var unread := StoryLibrary.catalog.filter(_is_new)
		var years := "%s – %s" % [StoryLibrary.catalog.front()["year"], StoryLibrary.catalog.back()["year"]]
		spec = {"to": COSSACK_PHOTO, "reveal": StoryImage.Reveal.FADE, "duration": 0.6,
				"motion": StoryImage.Motion.PUSH_IN, "focus": Vector2(0.5, 0.3)}
		caps = years
		title = tr("home_tagline")
		entry = unread.front() if not unread.is_empty() else StoryLibrary.catalog.front()
	else:
		spec = BackgroundImages.cover_spec(entry)
		spec.merge({"motion": StoryImage.Motion.PUSH_IN, "duration": 0.6}, true)
		caps = tr("home_continue").to_upper()
		title = entry["title"]
		percent = StoryLibrary.progress(entry)["percent"]

	var picture := StoryImage.from_spec(spec)
	picture.fit = StoryImage.Fit.COVER
	picture.corner_radius = 1.0
	picture.bottom_shade = 0.0
	picture.motion_duration = 18.0

	var title_label := UI.label(title, &"Display", false)
	title_label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	var text := UI.vbox([UI.label(caps, &"Caps", false), title_label], 4)
	if percent >= 0:
		var line := ThinWidgets.progress_line(percent, AppTheme.hairline, AppTheme.accent)
		line.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		line.size_flags_vertical = Control.SIZE_SHRINK_CENTER
		var percent_label := UI.label("%d%%" % percent, &"Caps", false)
		var row := HBoxContainer.new()
		row.add_theme_constant_override("separation", 10)
		row.add_child(line)
		row.add_child(percent_label)
		text.add_child(UI.margin(row, 0, 8))
	else:
		var begin := HBoxContainer.new()
		begin.add_theme_constant_override("separation", 2)
		begin.add_child(UI.label(tr("home_begin"), &"Caps", false))
		begin.add_child(LineIcon.create(LineIcon.Kind.CHEVRON_RIGHT, 14, AppTheme.accent))
		text.add_child(UI.margin(begin, 0, 6))
	text.size_flags_vertical = Control.SIZE_SHRINK_END

	picture.custom_minimum_size.y = 150
	var card := UI.vbox([picture, UI.margin(text, 2, 16, 2, 18), ThinWidgets.hairline()])
	return Pressable.wrap(card, _on_card_pressed.bind(entry, percent >= 0))


func _on_card_pressed(entry: Dictionary, continuing: bool) -> void:
	if continuing:
		ReaderScreen.open(entry, false, Router.Transition.PLATFORM)
	else:
		Router.instance.push(StoryScreen.create(entry))


func _is_new(entry: Dictionary) -> bool:
	return StoryLibrary.progress(entry)["status"] == StoryLibrary.Status.NEW


func _fill_chips() -> void:
	for child in _chips.get_children():
		child.queue_free()
	for option in [[Filter.ALL, "filter_all"], [Filter.NEW, "filter_new"],
			[Filter.READING, "filter_reading"], [Filter.FINISHED, "filter_finished"]]:
		_chips.add_child(ThinWidgets.chip(option[1], option[0] == _filter, _set_filter.bind(option[0])))


func _set_filter(filter: Filter) -> void:
	_filter = filter
	_fill_chips()
	_fill_list(true)


func _fill_list(animate: bool) -> void:
	for child in _list.get_children():
		child.queue_free()
	var entries := StoryLibrary.catalog.filter(_matches)
	_count.text = str(entries.size())
	if entries.is_empty():
		var empty := UI.label("filter_empty", &"Meta")
		empty.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
		_list.add_child(UI.margin(empty, 0, 40, 0, 40))
		return
	for i in entries.size():
		var row := StoryRow.new()
		row.entry = entries[i]
		row.first = i == 0
		row.last = i == entries.size() - 1
		row.opened.connect(func(e: Dictionary) -> void: Router.instance.push(StoryScreen.create(e)))
		_list.add_child(row)
		if animate:
			# Rows fade in one after another.
			row.modulate.a = 0.0
			var tween := row.create_tween()
			tween.tween_interval(0.04 * i)
			tween.tween_property(row, "modulate:a", 1.0, 0.28).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT)


func _matches(entry: Dictionary) -> bool:
	if _filter == Filter.ALL:
		return true
	var status: StoryLibrary.Status = StoryLibrary.progress(entry)["status"]
	match _filter:
		Filter.NEW:
			return status == StoryLibrary.Status.NEW
		Filter.READING:
			return status == StoryLibrary.Status.READING
	return status == StoryLibrary.Status.FINISHED


func _footer() -> Control:
	var link := UI.label("labelSiteLink", &"Meta")
	var site := Pressable.wrap(link, Platform.open_url.bind(SITE_URL))
	site.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	var version := UI.label("%s %s" % [tr("version"), ProjectSettings.get_setting("application/config/version")], &"Meta", false)
	var row := HBoxContainer.new()
	row.add_child(site)
	row.add_child(version)
	return UI.vbox([ThinWidgets.hairline(), UI.margin(row, 0, 14)])


func _open_settings() -> void:
	_sheet = SettingsSheet.new()
	add_child(UI.fill_parent(_sheet))
	_sheet.closed.connect(func() -> void: _sheet = null)
