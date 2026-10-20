class_name ThinWidgets
extends RefCounted
## Builders for the thin design: hairlines, buttons, segmented control, switch,
## progress line, timeline rail and the gradient that keeps text readable on photos.


static func hairline(vertical := false) -> ColorRect:
	var line := ColorRect.new()
	line.mouse_filter = Control.MOUSE_FILTER_IGNORE
	if vertical:
		line.custom_minimum_size.x = 1
	else:
		line.custom_minimum_size.y = 1
	line.color = AppTheme.hairline
	return line


## Panel with the stylebox [param style] builds. Screens of the thin design rebuild
## on theme changes, so widgets don't listen themselves.
static func panel(style: Callable, child: Control = null) -> PanelContainer:
	var p := PanelContainer.new()
	p.add_theme_stylebox_override("panel", style.call())
	if child:
		p.add_child(child)
	return p


## Full-width accent button (52 px, radius 12).
static func primary_button(text: String, on_pressed: Callable, translate := true) -> Pressable:
	var label := UI.centered_label(text, &"PrimaryText", translate)
	var box := panel(func() -> StyleBox: return AppTheme.flat(AppTheme.accent, 12), label)
	box.custom_minimum_size.y = 52
	return Pressable.wrap(box, on_pressed)


## Quiet text action with a 48 px tap target.
static func quiet_button(text: String, on_pressed: Callable, translate := true) -> Pressable:
	var label := UI.centered_label(text, &"ButtonQuiet", translate)
	var box := panel(func() -> StyleBox: return AppTheme.flat(Color.TRANSPARENT), label)
	box.custom_minimum_size.y = 48
	return Pressable.wrap(box, on_pressed)


## Text filter tab, with a fine underline for the selected option.
static func chip(text: String, selected: bool, on_pressed: Callable) -> Pressable:
	var label := UI.centered_label(text, &"Meta")
	label.autowrap_mode = TextServer.AUTOWRAP_OFF
	if selected:
		label.add_theme_color_override("font_color", AppTheme.accent)
	var underline := hairline()
	underline.color = AppTheme.accent if selected else Color.TRANSPARENT
	var box := UI.vbox([UI.margin(label, 9, 10, 9, 10), underline])
	var pressable := Pressable.wrap(box, on_pressed)
	pressable.size_flags_horizontal = Control.SIZE_SHRINK_BEGIN
	return pressable


## Options side by side in one outlined capsule; [param options] are
## [value, translation key] or [value, text, font size] entries.
static func segmented(options: Array, current: Variant, on_selected: Callable) -> Control:
	var row := HBoxContainer.new()
	row.add_theme_constant_override("separation", 0)
	for option in options:
		var selected: bool = option[0] == current
		var label := UI.centered_label(option[1], &"Meta")
		label.autowrap_mode = TextServer.AUTOWRAP_OFF
		if option.size() > 2:
			label.add_theme_font_size_override("font_size", option[2])
		if selected:
			label.add_theme_color_override("font_color", AppTheme.ink)
		var style := func() -> StyleBox:
			return AppTheme.flat(AppTheme.surface if selected else Color.TRANSPARENT, 9)
		var cell := panel(style, label)
		cell.custom_minimum_size.y = 36
		var pressable := Pressable.wrap(cell, on_selected.bind(option[0]))
		pressable.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		row.add_child(pressable)
	var outline := func() -> StyleBox: return AppTheme.flat(Color.TRANSPARENT, 11, AppTheme.hairline, 2)
	return panel(outline, row)


static func toggle(value: bool, on_toggled: Callable) -> Control:
	var switch := ThinSwitch.new()
	switch.on = value
	switch.toggled.connect(on_toggled)
	return switch


static func progress_line(percent: float, track := Color.TRANSPARENT, fill := Color.TRANSPARENT) -> Control:
	var line := ThinProgress.new()
	line.value = percent / 100.0
	line.track = track
	line.fill = fill
	return line


## Linear gradient from transparent to [param bottom] alpha of black, top to bottom.
static func scrim_gradient(bottom := 0.7) -> Control:
	var rect := ThinGradient.new()
	rect.bottom_alpha = bottom
	return rect


class ThinSwitch:
	extends Control
	signal toggled(on: bool)
	var on := false
	var _knob := 0.0

	func _init() -> void:
		custom_minimum_size = Vector2(44, 26)
		size_flags_horizontal = Control.SIZE_SHRINK_END
		size_flags_vertical = Control.SIZE_SHRINK_CENTER

	func _ready() -> void:
		_knob = 1.0 if on else 0.0
		AppTheme.changed.connect(queue_redraw)

	func _gui_input(event: InputEvent) -> void:
		if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and not event.pressed:
			on = not on
			Platform.haptic_light()
			var tween := create_tween().set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT)
			tween.tween_method(_set_knob, _knob, 1.0 if on else 0.0, 0.16)
			toggled.emit(on)

	func _set_knob(value: float) -> void:
		_knob = value
		queue_redraw()

	func _draw() -> void:
		var track := Rect2(Vector2.ZERO, size)
		var fill := AppTheme.accent if _knob > 0.5 else Color.TRANSPARENT
		draw_style_box(AppTheme.flat(fill.lerp(AppTheme.accent, _knob) if _knob > 0.0 else fill, 13,
				AppTheme.hairline if _knob < 0.5 else Color.TRANSPARENT), track)
		var r := size.y / 2.0 - 3.0
		var x := lerpf(r + 3.0, size.x - r - 3.0, _knob)
		draw_circle(Vector2(x, size.y / 2.0), r, AppTheme.on_accent if _knob > 0.5 else AppTheme.ink_soft, true, -1.0, true)


class ThinProgress:
	extends Control
	var value := 0.0
	var track := Color.TRANSPARENT
	var fill := Color.TRANSPARENT

	func _init() -> void:
		custom_minimum_size.y = 2
		mouse_filter = Control.MOUSE_FILTER_IGNORE

	func _ready() -> void:
		AppTheme.changed.connect(queue_redraw)

	func _draw() -> void:
		draw_rect(Rect2(0, 0, size.x, size.y), track if track.a > 0.0 else AppTheme.hairline)
		draw_rect(Rect2(0, 0, size.x * clampf(value, 0.0, 1.0), size.y), fill if fill.a > 0.0 else AppTheme.accent)


class ThinGradient:
	extends Control
	var bottom_alpha := 0.7

	func _init() -> void:
		mouse_filter = Control.MOUSE_FILTER_IGNORE

	func _draw() -> void:
		var clear := Color(0, 0, 0, 0)
		var dark := Color(0, 0, 0, bottom_alpha)
		draw_polygon(PackedVector2Array([Vector2.ZERO, Vector2(size.x, 0), size, Vector2(0, size.y)]),
				PackedColorArray([clear, clear, dark, dark]))
