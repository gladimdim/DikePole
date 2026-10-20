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
	var before := reader.story.history.size()
	var next := _find_button("next", reader)
	if next:
		await _tap(next)
		await _wait(0.8)
		_check(reader.story.history.size() == before + 1, "Next shows the next passage")
	else:
		_check(not reader.story.can_continue(), "the reader shows choices or an ending")


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


## The SlideableButton whose label is the translation key [param key].
func _find_button(key: String, root: Node = null) -> SlideableButton:
	for node in (root if root else get_tree().root).find_children("*", "SlideableButton", true, false):
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
