class_name LineIcon
extends Control
## Thin outline icons of the home and story screens, drawn with 1.5 px strokes.

enum Kind { GEAR, CHEVRON_LEFT, CHEVRON_RIGHT, CLOCK, FLAG, CHECK, CLOSE, BRANCH }

const STROKE := 1.5

var kind := Kind.GEAR:
	set(value):
		kind = value
		queue_redraw()
## Color override; theme ink when transparent.
var color := Color.TRANSPARENT:
	set(value):
		color = value
		queue_redraw()


static func create(icon: Kind, icon_size := 22.0, icon_color := Color.TRANSPARENT) -> LineIcon:
	var line_icon := LineIcon.new()
	line_icon.kind = icon
	line_icon.color = icon_color
	line_icon.custom_minimum_size = Vector2(icon_size, icon_size)
	return line_icon


func _init() -> void:
	mouse_filter = Control.MOUSE_FILTER_IGNORE


func _ready() -> void:
	AppTheme.changed.connect(queue_redraw)


func _draw() -> void:
	var c := color if color.a > 0.0 else AppTheme.ink
	var s := minf(size.x, size.y) / 24.0
	var o := (size - Vector2(24, 24) * s) / 2.0
	var p := func(x: float, y: float) -> Vector2: return o + Vector2(x, y) * s
	var w := STROKE * maxf(1.0, s)
	match kind:
		Kind.GEAR:
			draw_arc(p.call(12, 12), 3.0 * s, 0, TAU, 32, c, w, true)
			draw_arc(p.call(12, 12), 6.5 * s, 0, TAU, 48, c, w, true)
			for i in 8:
				var a := TAU * i / 8.0
				var d := Vector2(cos(a), sin(a))
				draw_line(p.call(12, 12) + d * 6.5 * s, p.call(12, 12) + d * 9.5 * s, c, w, true)
		Kind.CHEVRON_LEFT:
			draw_polyline(PackedVector2Array([p.call(15, 5), p.call(8, 12), p.call(15, 19)]), c, w, true)
		Kind.CHEVRON_RIGHT:
			draw_polyline(PackedVector2Array([p.call(9, 5), p.call(16, 12), p.call(9, 19)]), c, w, true)
		Kind.CLOCK:
			draw_arc(p.call(12, 12), 8.5 * s, 0, TAU, 48, c, w, true)
			draw_polyline(PackedVector2Array([p.call(12, 7), p.call(12, 12), p.call(15.5, 14)]), c, w, true)
		Kind.FLAG:
			draw_line(p.call(6, 3.5), p.call(6, 21), c, w, true)
			draw_polyline(PackedVector2Array([p.call(6, 4.5), p.call(18, 4.5), p.call(15, 8.5),
					p.call(18, 12.5), p.call(6, 12.5)]), c, w, true)
		Kind.CHECK:
			draw_polyline(PackedVector2Array([p.call(5, 12.5), p.call(10, 17.5), p.call(19, 7)]), c, w, true)
		Kind.CLOSE:
			draw_line(p.call(6, 6), p.call(18, 18), c, w, true)
			draw_line(p.call(18, 6), p.call(6, 18), c, w, true)
		Kind.BRANCH:
			draw_line(p.call(7, 3), p.call(7, 21), c, w, true)
			draw_polyline(PackedVector2Array([p.call(7, 15), p.call(17, 9), p.call(17, 4)]), c, w, true)
			draw_circle(p.call(17, 4), 1.6 * s, c, true, -1.0, true)
			draw_circle(p.call(7, 21), 1.6 * s, c, true, -1.0, true)
