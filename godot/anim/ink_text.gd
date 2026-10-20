class_name InkText
extends Label
## Reveal shaped text without changing line wrapping or the paragraph's height.
## Stops processing when finished; punctuation gives the writing a natural rhythm.

signal finished

var writing := false
var _remaining_delay := 0.0


func _init() -> void:
	theme_type_variation = &"Book"
	auto_translate_mode = Node.AUTO_TRANSLATE_MODE_DISABLED
	autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	visible_characters_behavior = TextServer.VC_CHARS_AFTER_SHAPING
	set_process(false)


func begin() -> void:
	visible_characters = 0
	_remaining_delay = 0.16
	writing = true
	set_process(true)


func finish() -> void:
	if not writing:
		return
	writing = false
	visible_characters = -1
	set_process(false)
	finished.emit()


func _process(delta: float) -> void:
	_remaining_delay -= delta
	while _remaining_delay <= 0.0 and writing:
		if visible_characters >= text.length():
			finish()
			return
		var character := text.substr(visible_characters, 1)
		visible_characters += 1
		_remaining_delay += 0.016
		if character in [".", "!", "?", "…", "\n"]:
			_remaining_delay += 0.16
		elif character in [",", ";", ":", "—"]:
			_remaining_delay += 0.065
