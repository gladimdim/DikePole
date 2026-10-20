class_name RadioDot
extends Control
## Material Radio: 2 px ring of radius 8 and an inner dot of radius 4.5 when selected,
## inside a 48×48 tap target.

signal selected

var checked := false:
	set(value):
		checked = value
		queue_redraw()


func _init() -> void:
	custom_minimum_size = Vector2(48, 48)


func _ready() -> void:
	AppTheme.changed.connect(queue_redraw)


func _gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and not event.pressed:
		selected.emit()


func _draw() -> void:
	var center := size / 2.0
	draw_arc(center, 7.0, 0.0, TAU, 48, AppTheme.primary, 2.0, true)
	if checked:
		draw_circle(center, 4.5, AppTheme.primary, true, -1.0, true)
