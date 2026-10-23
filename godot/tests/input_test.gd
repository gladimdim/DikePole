extends Node
## Drives the app with real touch events (tap, swipe), the way a phone does:
##   godot --path . -- --input-test [--classic]
## Prints ok/FAIL per step and quits with the number of failures.

var _failures := 0


func _ready() -> void:
	var classic := "--classic" in OS.get_cmdline_user_args()
	AppPrefs.classic_look = classic
	await _wait(0.3)
	if classic:
		await _run_classic()
	else:
		await _run_home()
	print("input test: %d failure(s)" % _failures)
	get_tree().quit(_failures)


func _run_home() -> void:
	await _wait(0.8)
	var home := Router.instance.top() as HomeScreen
	_check(home != null, "the home screen is shown")
	if home == null:
		return
	var center := home.get_global_rect().get_center()
	await _swipe(center + Vector2(0, 200), center - Vector2(0, 150))
	await _wait(0.4)
	_check(home._scroll.scroll_vertical > 0, "swiping scrolls the story list")
	home._scroll.scroll_vertical = 0
	await _wait(0.3)

	var gear: Pressable = home.find_children("*", "Pressable", true, false)[0]
	await _tap(gear)
	await _wait(0.6)
	_check(home._sheet != null, "the gear opens the settings")
	# Each size change rebuilds the home screen; the sheet must stay on top of it.
	var scale_before := AppPrefs.text_scale
	for index in [3, 1]:
		var sizes := home._sheet._sheet.find_children("*", "Control", true, false).filter(
				func(node: Control) -> bool: return node is Pressable or node is BaseButton).filter(
				func(node: Control) -> bool: return node.find_children("*", "Label", true, false).any(
						func(label: Label) -> bool: return label.text == "Aa"))
		await _tap(sizes[index] if index < sizes.size() else null)
		await _wait(0.6)
		_check(AppPrefs.text_scale == AppPrefs.TEXT_SCALES[index] and Router.instance.top() == home,
				"tapping text size %d in the open settings changes it" % index)
	AppPrefs.text_scale = scale_before
	await _wait(0.3)
	get_tree().root.propagate_notification(NOTIFICATION_WM_GO_BACK_REQUEST)
	await _wait(0.5)
	_check(home._sheet == null and Router.instance.depth() == 1, "back closes the settings")

	var row: StoryRow = home.find_children("*", "StoryRow", true, false)[0]
	await _tap(row.get_child(row.get_child_count() - 1))
	await _wait(1.0)
	_check(Router.instance.top() is StoryScreen, "a story row opens the story page")

	var primary := _find_pressable_with_variation(Router.instance.top(), &"PrimaryText")
	await _tap(primary)
	await _wait(1.0)
	_check(Router.instance.top() is ReaderScreen, "the main button opens the reader")
	await _next_in_reader()
	await _reader_settings()

	get_tree().root.propagate_notification(NOTIFICATION_WM_GO_BACK_REQUEST)
	await _wait(0.8)
	_check(Router.instance.top() is StoryScreen, "back returns to the story page")
	get_tree().root.propagate_notification(NOTIFICATION_WM_GO_BACK_REQUEST)
	await _wait(0.8)
	_check(Router.instance.top() is HomeScreen, "back returns home")


func _run_classic() -> void:
	await _wait(0.5)
	await _tap(_find_button("start"))
	await _wait(1.0)
	_check(Router.instance.depth() == 2, "Start opens the catalog")
	await _wait(2.0)
	var pager: VerticalPager = Router.instance.top().find_children("*", "VerticalPager", true, false)[0]
	var center := pager.get_global_rect().get_center()
	await _swipe(center, center - Vector2(0, 260))
	await _wait(1.2)
	_check(is_equal_approx(pager.page, 1.0), "swipe up moves to the next story (page %.2f)" % pager.page)
	await _tap(_find_button("startstory", _visible_card(pager)))
	await _wait(1.2)
	_check(Router.instance.top() is ReaderScreen, "Read opens the story")
	await _next_in_reader()
	get_tree().root.propagate_notification(NOTIFICATION_WM_GO_BACK_REQUEST)
	await _wait(0.8)
	_check(Router.instance.depth() == 2, "Android back returns to the catalog")


func _next_in_reader() -> void:
	var reader := Router.instance.top() as ReaderScreen
	if reader == null:
		return
	if not AppPrefs.classic_look:
		reader._reset()
		await _wait(0.35)
		_check(reader._writing.writing and reader._writing.visible_characters > 0,
				"new passage writes progressively")
		var paragraph_height := reader._writing.size.y
		var initial_count := reader.story.history.size()
		await _tap(_find_button("reader_show_text", reader))
		await _wait(0.1)
		_check(not reader._writing.writing and reader.story.history.size() == initial_count,
				"reveal finishes the text without advancing the story")
		_check(is_equal_approx(paragraph_height, reader._writing.size.y),
				"writing preserves paragraph layout")
	var before := reader.story.history.size()
	var next := _find_button("next", reader)
	if next:
		await _tap(next)
		await _wait(0.8)
		_check(reader.story.history.size() == before + 1, "Next shows the next passage")
		if not AppPrefs.classic_look:
			reader._attach(StoryLibrary.open(reader.entry))
			await _wait(0.1)
			_check(not is_instance_valid(reader._writing) or not reader._writing.writing,
					"saved history appears immediately on resume")
			reader._reset()
			await _wait(0.1)
			reader._reset()
			await _wait(0.1)
			_check(reader._history_box.get_child_count() == 1 and reader._writing.writing,
					"reset during writing replaces the previous animation")
			reader._attach(StoryLibrary.open(reader.entry), true)
			await _wait(0.1)
			_check(not is_instance_valid(reader._writing) or not reader._writing.writing,
					"even a single saved passage resumes without replaying")
			while reader.story.can_continue():
				reader._finish_writing()
				reader._on_next()
				await _wait(0.02)
			reader._finish_writing()
			await _wait(0.2)
			if reader.story.current_page.has_next():
				var path_length := reader.story.path.size()
				var choices := reader._controls.find_children("*", "Pressable", true, false)
				await _tap(choices[0])
				await _wait(0.2)
				_check(reader.story.path.size() == path_length + 1,
						"a revealed choice advances to its story branch")
	else:
		_check(not reader.story.can_continue(), "the reader shows choices or an ending")


## Menu > Settings in the reader: the text size changes the story text in place.
func _reader_settings() -> void:
	var reader := Router.instance.top() as ReaderScreen
	if reader == null:
		return
	var menu: Control = null
	for label in reader.find_children("*", "Label", true, false):
		if label.text == "menu":
			menu = label.get_parent()
	await _tap(menu)
	await _wait(0.3)
	var item: Control = null
	for label in reader.find_children("*", "Label", true, false):
		if label.text == "settings_title" and label.is_visible_in_tree():
			item = label
	await _tap(item)
	await _wait(0.6)
	_check(reader._sheet != null, "the reader menu opens the settings")
	if reader._sheet == null:
		return
	var scale_before := AppPrefs.text_scale
	var book_size := AppTheme.theme.get_font_size("font_size", "Book")
	var sizes := reader._sheet._sheet.find_children("*", "Pressable", true, false).filter(
			func(node: Control) -> bool: return node.find_children("*", "Label", true, false).any(
					func(label: Label) -> bool: return label.text == "Aa"))
	await _tap(sizes[3] if sizes.size() > 3 else null)
	await _wait(0.6)
	_check(AppTheme.theme.get_font_size("font_size", "Book") > book_size and Router.instance.top() == reader,
			"the largest text size enlarges the story text while reading")
	get_tree().root.propagate_notification(NOTIFICATION_WM_GO_BACK_REQUEST)
	await _wait(0.5)
	_check(reader._sheet == null and Router.instance.top() == reader, "back closes the reader settings")
	AppPrefs.text_scale = scale_before
	await _wait(0.2)


func _tap(control: Control) -> void:
	if control == null:
		_check(false, "control to tap exists")
		return
	var point := control.get_global_rect().get_center()
	await _touch(point, true)
	await _touch(point, false)


func _swipe(from: Vector2, to: Vector2) -> void:
	await _touch(from, true)
	for i in range(1, 11):
		var drag := InputEventScreenDrag.new()
		drag.position = from.lerp(to, i / 10.0)
		drag.relative = (to - from) / 10.0
		Input.parse_input_event(drag)
		await get_tree().process_frame
	await _touch(to, false)


func _touch(point: Vector2, pressed: bool) -> void:
	var touch := InputEventScreenTouch.new()
	touch.position = point
	touch.pressed = pressed
	Input.parse_input_event(touch)
	await get_tree().process_frame


## The classic or paper-style action with the translation key [param key].
func _find_button(key: String, root: Node = null) -> Control:
	for node in (root if root else get_tree().root).find_children("*", "Control", true, false):
		if not (node is SlideableButton or node is Pressable):
			continue
		for label in node.find_children("*", "Label", true, false):
			if label.text == key and node.is_visible_in_tree():
				return node
	return null


func _find_pressable_with_variation(root: Node, variation: StringName) -> Pressable:
	for node in root.find_children("*", "Pressable", true, false):
		for label in node.find_children("*", "Label", true, false):
			if label.theme_type_variation == variation:
				return node
	return null


func _visible_card(pager: VerticalPager) -> Node:
	var best: Control = null
	for card in pager.get_children():
		if best == null or absf(card.position.y - pager.size.y * 0.1) < absf(best.position.y - pager.size.y * 0.1):
			best = card
	return best


func _wait(seconds: float) -> void:
	await get_tree().create_timer(seconds).timeout


func _check(condition: bool, name: String) -> void:
	if not condition:
		_failures += 1
	print(("ok   " if condition else "FAIL ") + name)
