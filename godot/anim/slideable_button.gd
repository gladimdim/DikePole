class_name SlideableButton
extends Container
## Flutter SlideableButton: on tap the content slides off to the right by twice the
## screen width (200 ms, easeInOut), the action fires, then it slides back.

signal pressed

const DURATION := 0.2
## Flutter kTouchSlop: more movement than this is a drag, not a tap.
const TAP_SLOP := 18.0

var _offset_x := 0.0
var _press_position := Vector2.ZERO
var _pressing := false
var _running := false


static func wrap(content: Control, on_pressed: Callable) -> SlideableButton:
	var button := SlideableButton.new()
	button.add_child(content)
	button.pressed.connect(on_pressed)
	return button


func _init() -> void:
	mouse_filter = Control.MOUSE_FILTER_PASS
	size_flags_horizontal = Control.SIZE_EXPAND_FILL


func _ready() -> void:
	# Panels stop mouse events by default; the press must reach this button.
	for child in get_children():
		if child is Control:
			UI.pass_mouse(child)


func _notification(what: int) -> void:
	if what == NOTIFICATION_SORT_CHILDREN:
		for child in get_children():
			if child is Control:
				fit_child_in_rect(child, Rect2(Vector2(_offset_x, 0), size))


func _get_minimum_size() -> Vector2:
	var result := Vector2.ZERO
	for child in get_children():
		if child is Control and child.visible:
			result = result.max(child.get_combined_minimum_size())
	return result


func _gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		if event.pressed:
			_pressing = true
			_press_position = event.global_position
		elif _pressing:
			_pressing = false
			if event.global_position.distance_to(_press_position) < TAP_SLOP:
				tap()


func tap() -> void:
	if _running:
		return
	_running = true
	var width := get_viewport_rect().size.x * 2.0
	var tween := create_tween()
	FlutterCurves.tween_method(tween, _set_offset, 0.0, width, DURATION, FlutterCurves.EASE_IN_OUT)
	await tween.finished
	pressed.emit()
	if not is_inside_tree():
		return
	# easeInOut is symmetric, so the reverse run uses the same interpolation.
	tween = create_tween()
	FlutterCurves.tween_method(tween, _set_offset, width, 0.0, DURATION, FlutterCurves.EASE_IN_OUT)
	await tween.finished
	_running = false


func _set_offset(value: float) -> void:
	_offset_x = value
	queue_sort()
