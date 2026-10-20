class_name VerticalPager
extends Control
## Flutter PageView(scrollDirection: vertical, viewportFraction: 0.8) with
## TransformingPageView's horizontal shift of 100 px per page of distance.
## Drag to scroll; release snaps to a page with Flutter's page spring.

signal page_changed(page: float)

const VIEWPORT_FRACTION := 0.8
const SHIFT_PER_PAGE := 100.0
const TOUCH_SLOP := 18.0
const MIN_FLING_VELOCITY := 50.0
const MAX_FLING_VELOCITY := 8000.0
# Flutter ScrollPhysics spring: mass 0.5, stiffness 100, damping ratio 1.1.
const SPRING_MASS := 0.5
const SPRING_STIFFNESS := 100.0
const SPRING_DAMPING := 1.1 * 2.0 * 7.0710678  # ratio * 2 * sqrt(mass * stiffness)

## Current scroll position in pages (0 = first page centered).
var page := 0.0

var _pages: Array[Control] = []
var _pressed := false
var _dragging := false
var _press_y := 0.0
var _last_y := 0.0
var _samples: Array[Vector2] = []  # (time, y)
var _velocity := 0.0  # pixels per second, positive = towards later pages
var _target := -1.0


func _init() -> void:
	clip_contents = true
	mouse_filter = Control.MOUSE_FILTER_STOP


func _ready() -> void:
	# Pages build their widgets in their own _ready, which runs before this one.
	for page_content in _pages:
		UI.pass_mouse(page_content)


func add_page(content: Control) -> void:
	_pages.append(content)
	add_child(content)
	if is_node_ready():
		UI.pass_mouse(content)
	_layout()


func page_extent() -> float:
	return size.y * VIEWPORT_FRACTION


func _notification(what: int) -> void:
	if what == NOTIFICATION_RESIZED:
		_layout()


func _gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		if event.pressed:
			_pressed = true
			_dragging = false
			_target = -1.0
			set_process(false)
			_press_y = event.global_position.y
			_last_y = _press_y
			_samples = [Vector2(_now(), _press_y)]
		elif _pressed:
			_pressed = false
			if _dragging:
				_release()
			elif _target < 0.0:
				_settle(0.0)
	elif event is InputEventMouseMotion and _pressed:
		var y: float = event.global_position.y
		if not _dragging and absf(y - _press_y) > TOUCH_SLOP:
			_dragging = true
			_last_y = y
		if _dragging:
			_drag_by(_last_y - y)
			_last_y = y
			_samples.append(Vector2(_now(), y))
			if _samples.size() > 20:
				_samples.pop_front()


func _drag_by(pixels: float) -> void:
	var extent := page_extent()
	var next := page + pixels / extent
	var last := float(_pages.size() - 1)
	if next < 0.0 or next > last:
		if OS.get_name() == "iOS":
			next = page + pixels / extent * 0.5  # BouncingScrollPhysics-like resistance
		else:
			next = clampf(next, 0.0, last)
	_set_page(next)


func _release() -> void:
	# Velocity over the last 100 ms, like Flutter's VelocityTracker window.
	var now := _now()
	var first: Vector2 = _samples.back()
	for sample in _samples:
		if now - sample.x <= 0.1:
			first = sample
			break
	var last_sample: Vector2 = _samples.back()
	var dt := last_sample.x - first.x
	var velocity := (first.y - last_sample.y) / dt if dt > 0.0 else 0.0
	velocity = clampf(velocity, -MAX_FLING_VELOCITY, MAX_FLING_VELOCITY)
	_settle(velocity if absf(velocity) >= MIN_FLING_VELOCITY else 0.0)


## Flutter PageScrollPhysics._getTargetPixels + ScrollSpringSimulation.
func _settle(velocity: float) -> void:
	var target_page := page
	if velocity < 0.0:
		target_page -= 0.5
	elif velocity > 0.0:
		target_page += 0.5
	_target = clampf(roundf(target_page), 0.0, float(_pages.size() - 1))
	_velocity = velocity
	set_process(true)


func _process(delta: float) -> void:
	if _target < 0.0:
		set_process(false)
		return
	var extent := page_extent()
	var x := page * extent
	var goal := _target * extent
	# Integrate the spring in small steps for stability.
	var steps := 4
	var h := delta / steps
	for i in steps:
		var force := -SPRING_STIFFNESS * (x - goal) - SPRING_DAMPING * _velocity
		_velocity += force / SPRING_MASS * h
		x += _velocity * h
	if absf(x - goal) < 0.5 and absf(_velocity) < 10.0:
		x = goal
		_target = -1.0
		set_process(false)
	_set_page(x / extent)


func _set_page(value: float) -> void:
	page = value
	_layout()
	page_changed.emit(page)


func _layout() -> void:
	var extent := page_extent()
	var pad := (size.y - extent) / 2.0
	for i in _pages.size():
		var distance := page - float(i)
		var card := _pages[i]
		card.position = Vector2(SHIFT_PER_PAGE * absf(distance), pad + (float(i) - page) * extent)
		card.size = Vector2(size.x, extent)
		if card.has_method("set_scroll_value"):
			card.set_scroll_value(distance)


static func _now() -> float:
	return Time.get_ticks_usec() / 1000000.0
