class_name SettingsSheet
extends Control
## Bottom sheet with the reader's settings: theme, language, story text size,
## vibration and the classic look. Slides up over a dimmed home screen.

signal closed

const SLIDE := 0.28
const SCRIM_ALPHA := 0.45
const SITE_URL := "https://locadeserta.com/"

var _scrim: ColorRect
var _sheet: PanelContainer
var _closing := false


func _ready() -> void:
	_scrim = ColorRect.new()
	_scrim.color = Color(0, 0, 0, 0)
	_scrim.gui_input.connect(_on_scrim_input)
	add_child(UI.fill_parent(_scrim))
	_build_sheet()
	AppTheme.changed.connect(_rebuild)
	await get_tree().process_frame
	_sheet.position.y = size.y
	var tween := create_tween().set_parallel().set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT)
	tween.tween_property(_scrim, "color:a", SCRIM_ALPHA, SLIDE)
	tween.tween_property(_sheet, "position:y", size.y - _sheet.size.y, SLIDE)


func _notification(what: int) -> void:
	if what == NOTIFICATION_TRANSLATION_CHANGED and is_node_ready():
		_rebuild.call_deferred()


func close() -> void:
	if _closing:
		return
	_closing = true
	var tween := create_tween().set_parallel().set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_IN)
	tween.tween_property(_scrim, "color:a", 0.0, SLIDE * 0.8)
	tween.tween_property(_sheet, "position:y", size.y, SLIDE * 0.8)
	await tween.finished
	closed.emit()
	queue_free()


func _on_scrim_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and not event.pressed:
		close()


func _rebuild() -> void:
	if _closing:
		return
	_sheet.queue_free()
	_build_sheet()
	await get_tree().process_frame
	_sheet.position.y = size.y - _sheet.size.y


func _build_sheet() -> void:
	_sheet = PanelContainer.new()
	var box := AppTheme.flat(AppTheme.paper, 0)
	box.corner_radius_top_left = 20
	box.corner_radius_top_right = 20
	box.anti_aliasing = true
	_sheet.add_theme_stylebox_override("panel", box)
	_sheet.anchor_left = 0.0
	_sheet.anchor_right = 1.0
	_sheet.offset_left = 0.0
	_sheet.offset_right = 0.0
	_sheet.position.y = size.y - 600 if is_node_ready() else 4000.0

	var handle := PanelContainer.new()
	handle.add_theme_stylebox_override("panel", AppTheme.flat(AppTheme.hairline, 2))
	handle.custom_minimum_size = Vector2(36, 4)
	handle.size_flags_horizontal = Control.SIZE_SHRINK_CENTER

	var sizes := []
	for i in AppPrefs.TEXT_SCALES.size():
		sizes.append([AppPrefs.TEXT_SCALES[i], "Aa", [12, 14, 16, 19][i]])

	var content := UI.vbox([
		handle, UI.spacer(0, 18),
		UI.label("settings_title", &"H2"), UI.spacer(0, 22),
		_caption("settings_theme"),
		ThinWidgets.segmented([["light", "theme_light"], ["dark", "theme_dark"], ["system", "theme_system"]],
				AppPrefs.theme_mode, func(mode: String) -> void: AppPrefs.theme_mode = mode),
		UI.spacer(0, 20), _caption("settings_language"),
		ThinWidgets.segmented([["uk", "Українська"], ["en", "English"]], AppPrefs.language, _set_language),
		UI.spacer(0, 20), _caption("settings_text_size"),
		ThinWidgets.segmented(sizes, AppPrefs.text_scale, func(scale: float) -> void: AppPrefs.text_scale = scale),
		UI.spacer(0, 22), ThinWidgets.hairline(),
		_switch_row("settings_haptics", "", AppPrefs.haptics, func(on: bool) -> void: AppPrefs.haptics = on),
		ThinWidgets.hairline(),
		_switch_row("settings_classic", "settings_classic_hint", AppPrefs.classic_look, _set_classic),
		ThinWidgets.hairline(), UI.spacer(0, 16),
		_footer(),
	])
	_sheet.add_child(UI.margin(content, 24, 10, 24, 28))
	add_child(_sheet)


func _caption(key: String) -> Control:
	return UI.margin(UI.label(key, &"Meta"), 2, 0, 0, 8)


func _switch_row(key: String, hint: String, value: bool, on_toggled: Callable) -> Control:
	var text := UI.vbox([UI.label(key, &"Body")], 1)
	if hint != "":
		var hint_label := UI.label(hint, &"Meta")
		hint_label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
		text.add_child(hint_label)
	text.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	var row := HBoxContainer.new()
	row.add_theme_constant_override("separation", 12)
	row.add_child(text)
	row.add_child(ThinWidgets.toggle(value, on_toggled))
	return UI.margin(row, 0, 14, 0, 14)


func _footer() -> Control:
	var site := Pressable.wrap(UI.label("labelSiteLink", &"Meta"), Platform.open_url.bind(SITE_URL))
	site.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	var version := UI.label("%s %s" % [tr("version"), ProjectSettings.get_setting("application/config/version")], &"Meta", false)
	var row := HBoxContainer.new()
	row.add_child(site)
	row.add_child(version)
	return row


func _set_language(code: String) -> void:
	AppPrefs.language = code
	TranslationServer.set_locale(code)


## The classic look swaps the whole app to the original screens (main.gd).
func _set_classic(on: bool) -> void:
	await get_tree().create_timer(0.2).timeout
	AppPrefs.classic_look = on
