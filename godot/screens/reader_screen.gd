class_name ReaderScreen
extends Control
## Flutter GameView + StoryView: the scrolling history of passages with Next or the
## choices below, autosave on every step, and "Start over?" at an ending.

const SCROLL_DELAY := 0.3
const SCROLL_DURATION := 0.05

var entry: Dictionary
var story: GsStory

var _history_box: VBoxContainer
var _controls: VBoxContainer
var _scroll: ScrollContainer
var _shown := 0
var _end_row: Control
var _scroll_tween: Tween


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
	Router.instance.push(screen, transition)


func _ready() -> void:
	var actions: Array[Dictionary] = [
		{"text": "backtostories", "action": func() -> void: Router.instance.pop()},
		{"text": "reset", "action": _reset},
	]
	add_child(NarrowScaffold.create(_build_body(), entry["title"], actions, true, false))
	_attach(story)


func _build_body() -> Control:
	_history_box = UI.vbox()
	_history_box.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	_scroll = ScrollContainer.new()
	_scroll.horizontal_scroll_mode = ScrollContainer.SCROLL_MODE_DISABLED
	_scroll.vertical_scroll_mode = ScrollContainer.SCROLL_MODE_SHOW_NEVER
	_scroll.size_flags_vertical = Control.SIZE_EXPAND_FILL
	_scroll.add_child(_history_box)
	_controls = UI.vbox()
	return UI.margin(UI.vbox([_scroll, _controls]), 0, 32)


func _attach(new_story: GsStory) -> void:
	if story and story.history_changed.is_connected(_on_history_changed):
		story.history_changed.disconnect(_on_history_changed)
	story = new_story
	story.history_changed.connect(_on_history_changed)
	for child in _history_box.get_children():
		child.queue_free()
	_shown = 0
	_end_row = null
	_on_history_changed(story.history)


func _on_history_changed(history: Array[GsHistoryItem]) -> void:
	if history.size() < _shown:
		for child in _history_box.get_children():
			child.queue_free()
		_shown = 0
		_end_row = null
	# Only new items are added, so pictures already shown don't restart.
	for i in range(_shown, history.size()):
		var view := _passage_view(history[i])
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


func _passage_view(item: GsHistoryItem) -> Control:
	var parts := []
	if not item.image_paths.is_empty():
		var picture := StoryImage.from_spec(BackgroundImages.passage_spec(item.image_paths))
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


func _rebuild_controls() -> void:
	for child in _controls.get_children():
		child.queue_free()
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
	var screen_height := get_viewport_rect().size.y
	var button := SlideableButton.wrap(UI.fat("theendstartoverquestion", screen_height), func() -> void: story.reset())
	var row := UI.bordered(button)
	row.mouse_filter = Control.MOUSE_FILTER_PASS
	return row


func _on_next() -> void:
	Platform.haptic_light()
	if BackgroundImages.legacy_random:
		var node := story.current_page.get_current_node()
		if node and node.image_type != GsImageType.Type.NONE:
			BackgroundImages.next_random_for_type(node.image_type)
	story.do_continue()


func _on_choice(index: int) -> void:
	Platform.haptic_medium()
	story.go_to_next_page_by_index(index)


## Menu Reset: reload the story from the bundle and start from the beginning.
func _reset() -> void:
	_attach(StoryLibrary.reopen_from_start(entry))


## Flutter: 300 ms after each build, animateTo(maxScrollExtent, 50 ms, easeOutBack).
func _scroll_to_end() -> void:
	await get_tree().create_timer(SCROLL_DELAY).timeout
	if not is_inside_tree():
		return
	var bar := _scroll.get_v_scroll_bar()
	var target := maxf(0.0, bar.max_value - bar.page)
	if _scroll_tween:
		_scroll_tween.kill()
	_scroll_tween = create_tween()
	var set_scroll := func(v: float) -> void: _scroll.scroll_vertical = int(minf(v, target))
	FlutterCurves.tween_method(_scroll_tween, set_scroll, float(_scroll.scroll_vertical), target,
			SCROLL_DURATION, FlutterCurves.EASE_OUT_BACK)
