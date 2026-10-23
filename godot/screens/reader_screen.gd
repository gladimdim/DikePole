class_name ReaderScreen
extends Control
## Flutter GameView + StoryView: the scrolling history of passages with Next or the
## choices below, autosave on every step, and "Start over?" at an ending.

const SCROLL_DELAY := 0.3
const SCROLL_DURATION := 0.05

var entry: Dictionary
var story: GsStory
var resume_saved := false

var _history_box: VBoxContainer
var _controls: VBoxContainer
var _scroll: ScrollContainer
var _shown := 0
var _end_row: Control
var _scroll_tween: Tween
var _writing: InkText
var _latest_passage: Control
var _restoring := false
var _scroll_revision := 0
var _sheet: SettingsSheet


## Opens the story where the player left off (or from the beginning). The classic
## catalog slides it in diagonally, as Flutter did.
static func open(catalog_entry: Dictionary, from_start := false,
		transition := Router.Transition.SLIDE_DIAGONAL) -> void:
	var story := StoryLibrary.reopen_from_start(catalog_entry) if from_start else StoryLibrary.open(catalog_entry)
	if story == null:
		return
	var screen := ReaderScreen.new()
	screen.entry = catalog_entry
	screen.story = story
	screen.resume_saved = not from_start and not AppPrefs.load_story_state(story.id).is_empty()
	Router.instance.push(screen, transition)


func _ready() -> void:
	var actions: Array[Dictionary] = [
		{"text": "backtostories", "action": func() -> void: Router.instance.pop()},
		{"text": "reset", "action": _reset},
		{"text": "settings_title", "action": _open_settings},
	]
	add_child(NarrowScaffold.create(_build_body(), entry["title"], actions, true, false))
	_attach(story, resume_saved)


func _build_body() -> Control:
	_history_box = UI.vbox()
	_history_box.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	_scroll = ScrollContainer.new()
	_scroll.horizontal_scroll_mode = ScrollContainer.SCROLL_MODE_DISABLED
	_scroll.vertical_scroll_mode = ScrollContainer.SCROLL_MODE_SHOW_NEVER
	_scroll.size_flags_vertical = Control.SIZE_EXPAND_FILL
	_scroll.add_child(_history_box)
	_controls = UI.vbox()
	return UI.margin(UI.vbox([_scroll, _controls]), 0, 32 if AppPrefs.classic_look else 14)


func _attach(new_story: GsStory, restoring := false) -> void:
	_finish_writing()
	if story and story.history_changed.is_connected(_on_history_changed):
		story.history_changed.disconnect(_on_history_changed)
	story = new_story
	story.history_changed.connect(_on_history_changed)
	for child in _history_box.get_children():
		child.queue_free()
	_shown = 0
	_end_row = null
	_restoring = restoring or story.history.size() > 1
	_on_history_changed(story.history)
	_restoring = false


func _on_history_changed(history: Array[GsHistoryItem]) -> void:
	_finish_writing()
	if history.size() < _shown:
		for child in _history_box.get_children():
			child.queue_free()
		_shown = 0
		_end_row = null
	# Only new items are added, so pictures already shown don't restart.
	for i in range(_shown, history.size()):
		var view := _passage_view(history[i], not _restoring and i == history.size() - 1)
		_latest_passage = view
		# Let drags on the passages scroll the history.
		UI.pass_mouse(view)
		_history_box.add_child(view)
	_shown = history.size()
	if _end_row:
		_end_row.queue_free()
		_end_row = null
	# Also on pages with neither choices nor an ending (after_the_battle has six),
	# where the Flutter app left the reader without any button.
	if story.is_the_end() or (not story.can_continue() and not story.current_page.has_next()):
		_end_row = _start_over_row()
		_history_box.add_child(_end_row)
	_rebuild_controls()
	StoryLibrary.save(story)
	_scroll_to_end()


func _passage_view(item: GsHistoryItem, animate := false) -> Control:
	if not AppPrefs.classic_look:
		return _book_passage(item, animate)
	var parts := []
	if not item.image_paths.is_empty():
		var picture := StoryImage.from_spec(BackgroundImages.passage_spec(item.image_paths, item.node_id))
		picture.fit = StoryImage.Fit.WIDTH
		picture.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		parts.append(UI.bordered(picture))
	var text := UI.label(str(item.text) if item.text != null else tr("theend"), &"", false)
	text.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	# Flutter: Container(padding 8, margin 8, width 95 %) with a 3 px border.
	var box := UI.bordered(text, 8)
	box.custom_minimum_size.x = get_viewport_rect().size.x * 0.95
	box.size_flags_horizontal = Control.SIZE_SHRINK_CENTER
	parts.append(UI.margin_all(box, 8))
	(parts.back() as Control).size_flags_horizontal = Control.SIZE_SHRINK_CENTER
	return UI.vbox(parts)


func _book_passage(item: GsHistoryItem, animate: bool) -> Control:
	var parts := []
	if not item.image_paths.is_empty():
		var picture := StoryImage.from_spec(BackgroundImages.passage_spec(item.image_paths, item.node_id))
		picture.fit = StoryImage.Fit.WIDTH
		picture.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		parts.append(UI.margin(picture, 12, 8, 12, 20))
	var paragraph := InkText.new()
	paragraph.text = str(item.text) if item.text != null else tr("theend")
	parts.append(UI.margin(paragraph, 28, 6, 28, 20))
	var passage := UI.vbox(parts)
	passage.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	if animate:
		_writing = paragraph
		paragraph.begin()
		paragraph.finished.connect(_rebuild_controls)
	return passage


func _finish_writing() -> bool:
	if is_instance_valid(_writing) and _writing.writing:
		_writing.finish()
		return true
	return false


func _book_action(text: String, action: Callable, translate := true) -> Control:
	var label := UI.centered_label(text, &"BookAction", translate)
	var padded := UI.margin(label, 20, 12, 20, 12)
	padded.custom_minimum_size.y = 48
	return Pressable.wrap(padded, action)


func _rebuild_controls() -> void:
	for child in _controls.get_children():
		child.queue_free()
	if not AppPrefs.classic_look:
		_controls.add_child(UI.margin(ThinWidgets.hairline(), 28, 8, 28, 6))
		if is_instance_valid(_writing) and _writing.writing:
			_controls.add_child(_book_action("reader_show_text", _finish_writing))
		elif story.can_continue():
			_controls.add_child(_book_action("next", _on_next))
		else:
			for i in story.current_page.next.size():
				_controls.add_child(_book_action(str(story.current_page.next[i].text), _on_choice.bind(i), false))
		return
	var screen_height := get_viewport_rect().size.y
	if story.can_continue():
		var next := SlideableButton.wrap(UI.fat("next", screen_height), _on_next)
		_controls.add_child(UI.margin_all(UI.bordered(next), 8))
		return
	for i in story.current_page.next.size():
		var choice := story.current_page.next[i]
		var button := SlideableButton.wrap(UI.fat(str(choice.text), screen_height, false), _on_choice.bind(i))
		var holder := UI.bordered(button)
		holder.custom_minimum_size.y = screen_height * 0.075
		_controls.add_child(UI.margin_all(holder, 8))


func _start_over_row() -> Control:
	if not AppPrefs.classic_look:
		return _book_action("theendstartoverquestion", func() -> void:
			if not _finish_writing():
				story.reset())
	var screen_height := get_viewport_rect().size.y
	var button := SlideableButton.wrap(UI.fat("theendstartoverquestion", screen_height), func() -> void: story.reset())
	var row := UI.bordered(button)
	row.mouse_filter = Control.MOUSE_FILTER_PASS
	return row


func _on_next() -> void:
	if _finish_writing():
		return
	Platform.haptic_light()
	if BackgroundImages.legacy_random:
		var node := story.current_page.get_current_node()
		if node and node.image_type != GsImageType.Type.NONE:
			BackgroundImages.next_random_for_type(node.image_type)
	story.do_continue()


func _on_choice(index: int) -> void:
	if _finish_writing():
		return
	Platform.haptic_medium()
	story.go_to_next_page_by_index(index)


## Android back closes the settings first.
func handle_back() -> bool:
	if _sheet and is_instance_valid(_sheet):
		_sheet.close()
		_sheet = null
		return true
	return false


## Menu Settings: the home screen's sheet, so the text size changes while reading.
func _open_settings() -> void:
	_sheet = SettingsSheet.new()
	add_child(UI.fill_parent(_sheet))
	_sheet.closed.connect(func() -> void: _sheet = null)


## Menu Reset: reload the story from the bundle and start from the beginning.
func _reset() -> void:
	_attach(StoryLibrary.reopen_from_start(entry))


## Flutter: 300 ms after each build, animateTo(maxScrollExtent, 50 ms, easeOutBack).
func _scroll_to_end() -> void:
	_scroll_revision += 1
	var revision := _scroll_revision
	var restoring := _restoring
	await get_tree().create_timer(SCROLL_DELAY).timeout
	if not is_inside_tree() or revision != _scroll_revision:
		return
	var bar := _scroll.get_v_scroll_bar()
	var target := maxf(0.0, bar.max_value - bar.page)
	if not AppPrefs.classic_look and not restoring and is_instance_valid(_latest_passage):
		target = minf(target, _latest_passage.position.y)
	if _scroll_tween:
		_scroll_tween.kill()
	_scroll_tween = create_tween()
	var set_scroll := func(v: float) -> void: _scroll.scroll_vertical = int(minf(v, target))
	if AppPrefs.classic_look:
		FlutterCurves.tween_method(_scroll_tween, set_scroll, float(_scroll.scroll_vertical), target,
				SCROLL_DURATION, FlutterCurves.EASE_OUT_BACK)
	else:
		_scroll_tween.tween_method(set_scroll, float(_scroll.scroll_vertical), target, 0.35) \
				.set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT)
