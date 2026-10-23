extends Node
## Settings and reading progress (replaces SharedPreferences of the Flutter app).
## Settings live in user://prefs.json, progress in user://saves/<story id>.json.

signal changed(key: String)

const PREFS_PATH := "user://prefs.json"
const SAVES_DIR := "user://saves"

const THEME_MODES := ["light", "dark", "system"]
const TEXT_SCALES := [0.9, 1.0, 1.15, 1.3]

## "light", "dark" or "system". Older prefs only had the isDarkTheme flag.
var theme_mode: String:
	get:
		var mode: String = _values.get("themeMode", "dark" if _values.get("isDarkTheme", false) else "light")
		return mode if mode in THEME_MODES else "light"
	set(value):
		_values["isDarkTheme"] = value == "dark"
		_set_value("themeMode", value)

## Effective dark mode, following the device when the mode is "system".
var dark_theme: bool:
	get:
		if theme_mode == "system":
			return DisplayServer.is_dark_mode_supported() and DisplayServer.is_dark_mode()
		return theme_mode == "dark"
	set(value):
		theme_mode = "dark" if value else "light"

## Size of the story text relative to the original 18 px.
var text_scale: float:
	get:
		return float(_values.get("textScale", 1.0))
	set(value):
		_set_value("textScale", value)

var haptics: bool:
	get:
		return _values.get("haptics", true)
	set(value):
		_set_value("haptics", value)

## Original photo/sketch pairs and Flutter's plain cross-fade instead of the
## generated pictures and new animations. Not stored: only the tests turn it on.
var classic_look: bool:
	get:
		return _classic_look
	set(value):
		_classic_look = value
		changed.emit("classicLook")

var _values := {}
var _classic_look := false


func _init() -> void:
	var text := FileAccess.get_file_as_string(PREFS_PATH)
	var parsed = JSON.parse_string(text) if text != "" else null
	if parsed is Dictionary:
		_values = parsed
	_values.erase("classicLook")
	_values.erase("languageCode")
	DirAccess.make_dir_recursive_absolute(SAVES_DIR)


## Endings the reader has reached: page path -> "ALIVE", "DEAD" or "OPEN".
func endings_found(story_id: String) -> Dictionary:
	return _values.get("endings", {}).get(story_id, {})


func record_ending(story_id: String, page_path: String, kind: String) -> void:
	var all: Dictionary = _values.get("endings", {})
	var story: Dictionary = all.get(story_id, {})
	if story.get(page_path) == kind:
		return
	story[page_path] = kind
	all[story_id] = story
	_set_value("endings", all)


func load_story_state(story_id: String) -> Dictionary:
	var text := FileAccess.get_file_as_string(_save_path(story_id))
	var parsed = JSON.parse_string(text) if text != "" else null
	return parsed if parsed is Dictionary else {}


func save_story_state(story_id: String, state: Dictionary) -> void:
	_write(_save_path(story_id), JSON.stringify(state))


func _set_value(key: String, value: Variant) -> void:
	_values[key] = value
	_write(PREFS_PATH, JSON.stringify(_values, "\t"))
	changed.emit(key)


func _save_path(story_id: String) -> String:
	return "%s/%s.json" % [SAVES_DIR, story_id]


func _write(path: String, text: String) -> void:
	# Write to a temp file first so a crash mid-write can't corrupt the save.
	var temp := path + ".tmp"
	var file := FileAccess.open(temp, FileAccess.WRITE)
	if file == null:
		push_error("Cannot write %s: %s" % [path, error_string(FileAccess.get_open_error())])
		return
	file.store_string(text)
	file.close()
	DirAccess.rename_absolute(temp, path)
