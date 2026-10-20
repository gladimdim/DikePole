class_name Router
extends Control
## Screen stack with the Flutter route transitions and Hero flights.

enum Transition {
	NONE,
	## MaterialPageRoute default: Cupertino slide on iOS, fade-upwards elsewhere.
	PLATFORM,
	## SlideRightNavigation: in from Offset.fromDirection(0.8), 300 ms, linear.
	SLIDE_DIAGONAL,
}

const DURATION := 0.3
const DIAGONAL := Vector2(0.6967067, 0.7173561)  # (cos 0.8, sin 0.8)

static var instance: Router

## Overlay the hero shuttles fly in (set by main).
var hero_layer: Control

var _stack: Array[Control] = []
var _transitions: Array[Transition] = []
var _busy := false
## Bumped by reset_to so transitions of replaced screens stop.
var _generation := 0


func _ready() -> void:
	instance = self
	clip_contents = true


func top() -> Control:
	return _stack.back() if not _stack.is_empty() else null


func depth() -> int:
	return _stack.size()


func push(screen: Control, transition := Transition.PLATFORM) -> void:
	if _busy:
		return
	_busy = true
	var previous := top()
	UI.fill_parent(screen)
	screen.modulate.a = 0.0
	add_child(screen)
	_stack.append(screen)
	_transitions.append(transition)
	# Let the new screen lay out so hero destinations are known.
	var generation := _generation
	await get_tree().process_frame
	if generation != _generation:
		return
	var flights := _hero_flights(previous, screen, screen)
	await _run(previous, screen, transition, true, flights)
	if generation != _generation:
		return
	if is_instance_valid(previous):
		previous.visible = false
	_busy = false


## Replaces the whole stack with [param screen] (e.g. switching between the classic
## and the new design).
func reset_to(screen: Control) -> void:
	_generation += 1
	for old in _stack:
		old.queue_free()
	_stack.clear()
	_transitions.clear()
	_busy = false
	push(screen, Transition.NONE)


## Returns false when there is nothing to go back to. A screen may handle back
## itself (close a sheet) through handle_back() -> bool.
func pop() -> bool:
	var current := top()
	if current and current.has_method("handle_back") and current.handle_back():
		return true
	if _busy or _stack.size() <= 1:
		return false
	_pop()
	return true


func _pop() -> void:
	_busy = true
	var leaving: Control = _stack.pop_back()
	var transition: Transition = _transitions.pop_back()
	var revealed := top()
	revealed.visible = true
	# Screens refresh what may have changed meanwhile (progress after reading).
	if revealed.has_method("on_revealed"):
		revealed.on_revealed()
	var flights := _hero_flights(leaving, revealed, revealed)
	await _run(revealed, leaving, transition, false, flights)
	leaving.queue_free()
	_busy = false


## Animates [param upper] over [param lower]; forward = push, otherwise pop.
func _run(lower: Control, upper: Control, transition: Transition, forward: bool, flights: Array) -> void:
	var from := 0.0 if forward else 1.0
	var to := 1.0 if forward else 0.0
	_apply(lower, upper, transition, from, forward)
	if transition == Transition.NONE:
		_apply(lower, upper, transition, to, forward)
		return
	var step := func(t: float) -> void:
		_apply(lower, upper, transition, t, forward)
		for flight in flights:
			flight.step(t if forward else 1.0 - t)
	var tween := create_tween()
	tween.tween_method(step, from, to, DURATION)
	await tween.finished
	for flight in flights:
		flight.finish()
	if lower:
		lower.position = Vector2.ZERO
	upper.position = Vector2.ZERO
	upper.modulate.a = 1.0


## t is the route animation value (1 = upper screen fully in).
func _apply(lower: Control, upper: Control, transition: Transition, t: float, forward: bool) -> void:
	var screen_size := size
	match transition:
		Transition.NONE:
			upper.position = Vector2.ZERO
			upper.modulate.a = 1.0 if t > 0.0 else 0.0
		Transition.SLIDE_DIAGONAL:
			upper.modulate.a = 1.0
			upper.position = screen_size * DIAGONAL * (1.0 - t)
		Transition.PLATFORM:
			if OS.get_name() == "iOS":
				# CupertinoPageTransition: linearToEaseOut in, easeInToLinear back.
				var curve := FlutterCurves.LINEAR_TO_EASE_OUT if forward else FlutterCurves.EASE_IN_TO_LINEAR
				var v := FlutterCurves.transform(curve, t)
				upper.modulate.a = 1.0
				upper.position = Vector2(screen_size.x * (1.0 - v), 0)
				if lower:
					lower.position = Vector2(-screen_size.x / 3.0 * v, 0)
			else:
				# FadeUpwardsPageTransition: slide up 25 % with fastOutSlowIn, fade with easeIn.
				upper.position = Vector2(0, screen_size.y * 0.25 * (1.0 - FlutterCurves.transform(FlutterCurves.FAST_OUT_SLOW_IN, t)))
				upper.modulate.a = FlutterCurves.transform(FlutterCurves.EASE_IN, t)


## Pairs StoryImages with the same hero_tag on both screens. The shuttle shows the
## hero of [param shuttle_source], like Flutter's default flightShuttleBuilder.
func _hero_flights(from_screen: Control, to_screen: Control, shuttle_source: Control) -> Array:
	var flights := []
	if from_screen == null or hero_layer == null:
		return flights
	var targets := {}
	for hero in _heroes_in(to_screen):
		targets[hero.hero_tag] = hero
	for hero in _heroes_in(from_screen):
		if targets.has(hero.hero_tag):
			var target: StoryImage = targets[hero.hero_tag]
			var shuttle_hero: StoryImage = target if shuttle_source == to_screen else hero
			flights.append(HeroFlight.new(hero_layer, hero, target, shuttle_hero, _rect_in_place(to_screen, target)))
	return flights


func _heroes_in(screen: Control) -> Array[StoryImage]:
	var result: Array[StoryImage] = []
	for node in get_tree().get_nodes_in_group("heroes"):
		if node is StoryImage and screen.is_ancestor_of(node) and node.is_visible_in_tree():
			result.append(node)
	return result


## Destination rect with the screen at its resting place (Flutter measures the
## destination hero ignoring the route transition).
func _rect_in_place(screen: Control, hero: StoryImage) -> Rect2:
	var rect := hero.global_image_rect()
	rect.position -= screen.global_position - global_position
	return rect


class HeroFlight:
	var _shuttle: StoryImage
	var _from: StoryImage
	var _to: StoryImage
	var _begin: Rect2
	var _end: Rect2

	func _init(layer: Control, from: StoryImage, to: StoryImage, shuttle_hero: StoryImage, end_rect: Rect2) -> void:
		_from = from
		_to = to
		_begin = from.global_image_rect()
		_end = end_rect
		_shuttle = shuttle_hero.make_shuttle()
		layer.add_child(_shuttle)
		_from.modulate.a = 0.0
		_to.modulate.a = 0.0
		step(0.0)

	## t is 0 at the source hero and 1 at the destination.
	func step(t: float) -> void:
		var rect := MaterialArc.lerp_rect(_begin, _end, FlutterCurves.transform(FlutterCurves.FAST_OUT_SLOW_IN, t))
		_shuttle.position = rect.position
		_shuttle.size = rect.size
		_shuttle.fit_height = rect.size.y

	func finish() -> void:
		_shuttle.queue_free()
		for hero in [_from, _to]:
			if is_instance_valid(hero):
				hero.modulate.a = 1.0
