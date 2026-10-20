class_name FlutterCurves
extends RefCounted
## Flutter's `Cubic` curves, evaluated exactly like `Cubic.transform` (bisection with
## the same error bound), so tweens match the original app frame by frame.
## A curve is Vector4(x1, y1, x2, y2), the control points of the cubic bezier.

const EASE_IN := Vector4(0.42, 0.0, 1.0, 1.0)
const EASE_IN_OUT := Vector4(0.42, 0.0, 0.58, 1.0)
const LINEAR_TO_EASE_OUT := Vector4(0.35, 0.91, 0.33, 0.97)
const EASE_IN_TO_LINEAR := Vector4(0.67, 0.03, 0.65, 0.09)
const EASE_OUT_BACK := Vector4(0.175, 0.885, 0.32, 1.275)
const FAST_OUT_SLOW_IN := Vector4(0.4, 0.0, 0.2, 1.0)

const _CUBIC_ERROR_BOUND := 0.001


static func transform(curve: Vector4, t: float) -> float:
	if t <= 0.0:
		return 0.0
	if t >= 1.0:
		return 1.0
	var start := 0.0
	var end := 1.0
	while true:
		var midpoint := (start + end) / 2.0
		var estimate := _evaluate(curve.x, curve.z, midpoint)
		if absf(t - estimate) < _CUBIC_ERROR_BOUND:
			return _evaluate(curve.y, curve.w, midpoint)
		if estimate < t:
			start = midpoint
		else:
			end = midpoint
	return t


## For [method PropertyTweener.set_custom_interpolator].
static func interpolator(curve: Vector4) -> Callable:
	return func(t: float) -> float: return transform(curve, t)


## Calls [param setter] with values from [param from] to [param to] following
## [param curve] (MethodTweener has no custom interpolator).
static func tween_method(tween: Tween, setter: Callable, from: float, to: float,
		duration: float, curve: Vector4) -> MethodTweener:
	var curved := func(t: float) -> void: setter.call(lerpf(from, to, transform(curve, t)))
	return tween.tween_method(curved, 0.0, 1.0, duration)


static func _evaluate(a: float, b: float, m: float) -> float:
	return 3.0 * a * (1.0 - m) * (1.0 - m) * m + 3.0 * b * (1.0 - m) * m * m + m * m * m
