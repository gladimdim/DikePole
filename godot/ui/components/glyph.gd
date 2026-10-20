class_name Glyph
extends Control
## The few Material icons the app uses, drawn from their 24×24 SVG paths.

enum Kind { ARROW_BACK, DROP_DOWN, DROP_UP }

const _POINTS := {
	Kind.ARROW_BACK: [Vector2(20, 11), Vector2(7.83, 11), Vector2(13.42, 5.41), Vector2(12, 4),
			Vector2(4, 12), Vector2(12, 20), Vector2(13.41, 18.59), Vector2(7.83, 13), Vector2(20, 13)],
	Kind.DROP_DOWN: [Vector2(7, 10), Vector2(12, 15), Vector2(17, 10)],
	Kind.DROP_UP: [Vector2(7, 14), Vector2(12, 9), Vector2(17, 14)],
}

var kind := Kind.ARROW_BACK:
	set(value):
		kind = value
		queue_redraw()


static func create(glyph_kind: Kind) -> Glyph:
	var glyph := Glyph.new()
	glyph.kind = glyph_kind
	return glyph


func _init() -> void:
	custom_minimum_size = Vector2(24, 24)
	mouse_filter = Control.MOUSE_FILTER_IGNORE


func _ready() -> void:
	AppTheme.changed.connect(queue_redraw)


func _draw() -> void:
	var scale := size.y / 24.0
	var points := PackedVector2Array()
	for point in _POINTS[kind]:
		points.append(point * scale)
	draw_colored_polygon(points, AppTheme.primary)
