class_name StoryImage
extends Control
## A story picture with its reveal transition, Ken Burns motion and ambient overlay.
##
## In classic mode it reproduces Flutter's TweenImage exactly: two stacked images,
## opacity 1 - v and v, v going 0 → 1 linearly once over [member duration].

enum Reveal { FADE, SKETCH, DEVELOP, INK }
enum Motion { STATIC, PUSH_IN, PULL_OUT, PAN_LEFT, PAN_RIGHT, TILT_UP, TILT_DOWN }
enum Ambient { NONE, FIRE, MIST, WATER, WIND, RAIN, SNOW, SMOKE, DUST, NIGHT }
## How the picture is laid out, after Flutter's BoxFit usage in the original app.
enum Fit {
	WIDTH,   ## full width, height from the aspect ratio (BoxFit.fitWidth)
	HEIGHT,  ## fixed [member fit_height], cropped to the available width (BoxFit.fitHeight)
	CONTAIN, ## largest size inside the control, never above the image's own size
	COVER,   ## fills the control, cropping what doesn't fit (BoxFit.cover)
}

const SHADER := preload("res://anim/story_image.gdshader")
const MOTION_ZOOM := 1.08
const MOTION_PAN := 0.035

@export var from_texture: Texture2D
@export var to_texture: Texture2D
@export var reveal := Reveal.FADE
@export var classic := false
@export var duration := 4.0
@export var motion := Motion.STATIC
@export var focus := Vector2(0.5, 0.5)
@export var motion_duration := 14.0
@export var ambient := Ambient.NONE
@export var ambient_region := Rect2(0, 0, 1, 1)
@export var fit := Fit.WIDTH
@export var fit_height := 200.0
@export var corner_radius := 0.0
## 0..1 darkening of the lower part, for text laid over the picture.
@export var bottom_shade := 0.0
## Matching tags fly between screens on navigation (Flutter Hero).
@export var hero_tag := ""

var progress := 0.0:
	set(value):
		progress = value
		if _material:
			_material.set_shader_parameter("progress", value)

var _material: ShaderMaterial
var _elapsed := 0.0
var _motion_elapsed := 0.0


## Builds the picture from a spec of BackgroundImages.spec_for().
static func from_spec(spec: Dictionary) -> StoryImage:
	var image := StoryImage.new()
	image.apply_spec(spec)
	return image


func apply_spec(spec: Dictionary) -> void:
	to_texture = load(spec["to"])
	from_texture = load(spec["from"]) if spec.get("from", "") != "" else null
	reveal = spec.get("reveal", Reveal.FADE)
	classic = spec.get("classic", false)
	duration = spec.get("duration", 4.0)
	motion = spec.get("motion", Motion.STATIC)
	focus = spec.get("focus", Vector2(0.5, 0.5))
	ambient = spec.get("ambient", Ambient.NONE)
	ambient_region = spec.get("ambient_region", Rect2(0, 0, 1, 1))


func _ready() -> void:
	_material = ShaderMaterial.new()
	_material.shader = SHADER
	material = _material
	mouse_filter = Control.MOUSE_FILTER_IGNORE
	if hero_tag != "":
		add_to_group("heroes")
	AppTheme.changed.connect(_update_uniforms)
	_update_uniforms()
	_update_min_size()


## Continues the animation from where [param other] is (same picture shown twice).
func sync_with(other: StoryImage) -> void:
	_elapsed = other._elapsed
	_motion_elapsed = other._motion_elapsed
	set_process(true)


func restart() -> void:
	_elapsed = 0.0
	_motion_elapsed = 0.0
	progress = 0.0
	set_process(true)


func _process(delta: float) -> void:
	_elapsed += delta
	progress = clampf(_elapsed / duration, 0.0, 1.0) if duration > 0.0 else 1.0
	if motion != Motion.STATIC and not classic:
		_motion_elapsed += delta
		_update_view()
	elif progress >= 1.0 and ambient == Ambient.NONE:
		set_process(false)


func _notification(what: int) -> void:
	if what == NOTIFICATION_RESIZED:
		_update_min_size()
		queue_redraw()


func _draw() -> void:
	if to_texture == null:
		return
	var rect := image_rect()
	_update_maps(rect)
	draw_texture_rect(to_texture, rect, false)


## The rectangle the picture occupies, in local coordinates.
func image_rect() -> Rect2:
	if to_texture == null:
		return Rect2()
	match fit:
		Fit.WIDTH:
			return Rect2(0, 0, size.x, size.x * _max_height_ratio())
		Fit.HEIGHT:
			var width := minf(size.x, fit_height * _aspect(to_texture))
			return Rect2((size.x - width) / 2.0, 0, width, fit_height)
		Fit.COVER:
			return Rect2(Vector2.ZERO, size)
	var tex_size := to_texture.get_size()
	var scale := minf(1.0, minf(size.x / tex_size.x, size.y / tex_size.y))
	var drawn := tex_size * scale
	return Rect2((size - drawn) / 2.0, drawn)


func global_image_rect() -> Rect2:
	return get_global_transform() * image_rect()


## A copy for a Hero flight. Flutter flies the destination hero's child.
func make_shuttle() -> StoryImage:
	var shuttle := StoryImage.new()
	for property in ["from_texture", "to_texture", "reveal", "classic", "duration", "motion",
			"focus", "ambient", "ambient_region", "corner_radius"]:
		shuttle.set(property, get(property))
	shuttle.fit = Fit.COVER if fit == Fit.COVER else Fit.HEIGHT
	shuttle._elapsed = _elapsed
	return shuttle


func _update_min_size() -> void:
	if to_texture == null:
		return
	match fit:
		Fit.WIDTH:
			var height := size.x * _max_height_ratio()
			if not is_equal_approx(custom_minimum_size.y, height):
				custom_minimum_size.y = height
		Fit.HEIGHT:
			custom_minimum_size.y = fit_height


func _update_uniforms() -> void:
	if _material == null:
		return
	_material.set_shader_parameter("to_tex", to_texture)
	_material.set_shader_parameter("from_tex", from_texture)
	_material.set_shader_parameter("has_from", from_texture != null)
	_material.set_shader_parameter("reveal", reveal)
	_material.set_shader_parameter("classic", classic)
	_material.set_shader_parameter("progress", progress)
	_material.set_shader_parameter("background", AppTheme.background)
	_material.set_shader_parameter("ambient", Ambient.NONE if classic else ambient)
	_material.set_shader_parameter("ambient_region", Vector4(ambient_region.position.x,
			ambient_region.position.y, ambient_region.size.x, ambient_region.size.y))
	_material.set_shader_parameter("corner_radius", corner_radius)
	_material.set_shader_parameter("bottom_shade", bottom_shade)
	_update_view()


func _update_maps(rect: Rect2) -> void:
	_material.set_shader_parameter("rect_size", rect.size)
	_material.set_shader_parameter("to_map", _map_for(to_texture, rect))
	if from_texture:
		_material.set_shader_parameter("from_map", _map_for(from_texture, rect))


## Where each texture lands inside the drawn rect, mirroring how the two Flutter
## Image widgets of a TweenImage were laid out in their Stack.
func _map_for(texture: Texture2D, rect: Rect2) -> Vector4:
	if rect.size.x <= 0.0 or rect.size.y <= 0.0:
		return Vector4(0, 0, 1, 1)
	match fit:
		Fit.WIDTH:
			var fitted_height := rect.size.x / _aspect(texture)
			return Vector4(0, 0, 1, rect.size.y / fitted_height)
		Fit.HEIGHT:
			var painted_width := rect.size.y * _aspect(texture)
			var scale := rect.size.x / painted_width
			return Vector4((1.0 - scale) / 2.0, 0, scale, 1)
		Fit.COVER:
			var ratio := (rect.size.x / rect.size.y) / _aspect(texture)
			if ratio < 1.0:
				return Vector4((1.0 - ratio) / 2.0, 0, ratio, 1)
			return Vector4(0, (1.0 - 1.0 / ratio) / 2.0, 1, 1.0 / ratio)
	return Vector4(0, 0, 1, 1)


func _update_view() -> void:
	if _material == null:
		return
	var zoom := 1.0
	var center := Vector2(0.5, 0.5)
	if motion != Motion.STATIC and not classic:
		var t := _ease_sine(clampf(_motion_elapsed / motion_duration, 0.0, 1.0))
		match motion:
			Motion.PUSH_IN:
				zoom = lerpf(1.0, MOTION_ZOOM, t)
				center = Vector2(0.5, 0.5).lerp(focus, t * 0.6)
			Motion.PULL_OUT:
				zoom = lerpf(MOTION_ZOOM, 1.0, t)
				center = focus.lerp(Vector2(0.5, 0.5), t)
			Motion.PAN_LEFT:
				zoom = MOTION_ZOOM
				center = Vector2(0.5 + MOTION_PAN * (1.0 - 2.0 * t), 0.5)
			Motion.PAN_RIGHT:
				zoom = MOTION_ZOOM
				center = Vector2(0.5 - MOTION_PAN * (1.0 - 2.0 * t), 0.5)
			Motion.TILT_UP:
				zoom = MOTION_ZOOM
				center = Vector2(0.5, 0.5 + MOTION_PAN * (1.0 - 2.0 * t))
			Motion.TILT_DOWN:
				zoom = MOTION_ZOOM
				center = Vector2(0.5, 0.5 - MOTION_PAN * (1.0 - 2.0 * t))
		# Keep the zoomed view inside the picture.
		var half := 0.5 / zoom
		center = center.clamp(Vector2(half, half), Vector2(1.0 - half, 1.0 - half))
	_material.set_shader_parameter("view_zoom", zoom)
	_material.set_shader_parameter("view_center", center)


func _max_height_ratio() -> float:
	var ratio := 1.0 / _aspect(to_texture)
	if from_texture:
		ratio = maxf(ratio, 1.0 / _aspect(from_texture))
	return ratio


static func _aspect(texture: Texture2D) -> float:
	var tex_size := texture.get_size()
	return tex_size.x / tex_size.y if tex_size.y > 0.0 else 1.0


static func _ease_sine(t: float) -> float:
	return 0.5 - cos(t * PI) * 0.5
