class_name Pressable
extends Container
## Tap target of the thin design: the content dips to 97 % and dims slightly while
## pressed, and [signal pressed] fires on release. Drags beyond the touch slop
## cancel the tap so lists stay scrollable.

signal pressed

const TAP_SLOP := 18.0
const PRESS_SCALE := 0.97
const DURATION := 0.09

var haptic := true

var _press_position := Vector2.ZERO
var _pressing := false
var _tween: Tween


static func wrap(content: Control, on_pressed: Callable = Callable()) -> Pressable:
	var pressable := Pressable.new()
	pressable.add_child(content)
	if on_pressed.is_valid():
		pressable.pressed.connect(on_pressed)
	return pressable


func _init() -> void:
	mouse_filter = Control.MOUSE_FILTER_PASS


func _ready() -> void:
	for child in get_children():
		if child is Control:
			UI.pass_mouse(child)


func _notification(what: int) -> void:
	if what == NOTIFICATION_SORT_CHILDREN:
		pivot_offset = size / 2.0
		for child in get_children():
			if child is Control:
				fit_child_in_rect(child, Rect2(Vector2.ZERO, size))


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
			_animate(true)
		elif _pressing:
			_pressing = false
			_animate(false)
			if event.global_position.distance_to(_press_position) < TAP_SLOP:
				if haptic:
					Platform.haptic_light()
				pressed.emit()
	elif event is InputEventMouseMotion and _pressing:
		if event.global_position.distance_to(_press_position) >= TAP_SLOP:
			_pressing = false
			_animate(false)


func _animate(down: bool) -> void:
	if _tween:
		_tween.kill()
	_tween = create_tween().set_parallel().set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT)
	_tween.tween_property(self, "scale", Vector2.ONE * (PRESS_SCALE if down else 1.0), DURATION)
	_tween.tween_property(self, "modulate", Color(0.86, 0.86, 0.86) if down else Color.WHITE, DURATION)
