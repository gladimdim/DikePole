class_name MaterialArc
extends RefCounted
## Port of Flutter's MaterialRectArcTween / MaterialPointArcTween: the curved path a
## Hero flies along inside a MaterialApp.

const _ON_AXIS_DELTA := 2.0
# Corner ids: 0 top-left, 1 top-right, 2 bottom-left, 3 bottom-right.
const _DIAGONALS := [[0, 3], [3, 0], [1, 2], [2, 1]]


static func lerp_rect(begin: Rect2, end: Rect2, t: float) -> Rect2:
	var centers := end.get_center() - begin.get_center()
	var best: Array = _DIAGONALS[0]
	var best_support := -INF
	for diagonal in _DIAGONALS:
		var delta := _corner(begin, diagonal[1]) - _corner(begin, diagonal[0])
		var support := centers.dot(delta / delta.length()) if delta.length() > 0.0 else 0.0
		if support > best_support:
			best_support = support
			best = diagonal
	var a := lerp_point(_corner(begin, best[0]), _corner(end, best[0]), t)
	var b := lerp_point(_corner(begin, best[1]), _corner(end, best[1]), t)
	return Rect2(Vector2(minf(a.x, b.x), minf(a.y, b.y)), (a - b).abs())


static func lerp_point(begin: Vector2, end: Vector2, t: float) -> Vector2:
	if t <= 0.0:
		return begin
	if t >= 1.0:
		return end
	var delta := end - begin
	var dx := absf(delta.x)
	var dy := absf(delta.y)
	if dx <= _ON_AXIS_DELTA or dy <= _ON_AXIS_DELTA:
		return begin.lerp(end, t)
	var distance := delta.length()
	var c := Vector2(end.x, begin.y)
	var radius: float
	var center: Vector2
	var begin_angle: float
	var end_angle: float
	if dx < dy:
		radius = distance * distance / (c - begin).length() / 2.0
		center = Vector2(end.x + radius * signf(begin.x - end.x), end.y)
		var sweep := 2.0 * asin(distance / (2.0 * radius))
		if begin.x < end.x:
			begin_angle = sweep * signf(begin.y - end.y)
			end_angle = 0.0
		else:
			begin_angle = PI + sweep * signf(end.y - begin.y)
			end_angle = PI
	else:
		radius = distance * distance / (c - end).length() / 2.0
		center = Vector2(begin.x, begin.y + signf(end.y - begin.y) * radius)
		var sweep := 2.0 * asin(distance / (2.0 * radius))
		if begin.y < end.y:
			begin_angle = -PI / 2.0
			end_angle = begin_angle + sweep * signf(end.x - begin.x)
		else:
			begin_angle = PI / 2.0
			end_angle = begin_angle + sweep * signf(begin.x - end.x)
	var angle := lerpf(begin_angle, end_angle, t)
	return center + Vector2(cos(angle), sin(angle)) * radius


static func _corner(rect: Rect2, id: int) -> Vector2:
	match id:
		0:
			return rect.position
		1:
			return Vector2(rect.end.x, rect.position.y)
		2:
			return Vector2(rect.position.x, rect.end.y)
	return rect.end
