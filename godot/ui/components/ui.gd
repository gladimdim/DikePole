class_name UI
extends RefCounted
## Small builders for the recurring widgets of the Flutter app.


## Flutter BorderedContainer: background + 3 px border in the primary color.
## [param padding] is extra space inside the border (Flutter adds the border width).
static func bordered(child: Control = null, padding := 0) -> PanelContainer:
	var panel := PanelContainer.new()
	panel.theme_type_variation = &"Bordered"
	if padding > 0:
		var box: StyleBoxFlat = AppTheme.theme.get_stylebox("panel", "Bordered").duplicate()
		box.set_content_margin_all(AppTheme.BORDER + padding)
		panel.add_theme_stylebox_override("panel", box)
		AppTheme.changed.connect(func() -> void:
			if not is_instance_valid(panel):
				return
			var fresh: StyleBoxFlat = AppTheme.theme.get_stylebox("panel", "Bordered").duplicate()
			fresh.set_content_margin_all(AppTheme.BORDER + padding)
			panel.add_theme_stylebox_override("panel", fresh))
	if child:
		panel.add_child(child)
	return panel


## A box painted in the background color.
static func fill(child: Control = null, min_height := 0.0) -> PanelContainer:
	var panel := PanelContainer.new()
	panel.theme_type_variation = &"Fill"
	panel.custom_minimum_size.y = min_height
	if child:
		panel.add_child(child)
	return panel


## Label; [param text] is a translation key unless [param translate] is false.
static func label(text: String, variation := &"", translate := true) -> Label:
	var l := Label.new()
	l.text = text
	l.theme_type_variation = variation
	l.auto_translate_mode = Node.AUTO_TRANSLATE_MODE_ALWAYS if translate else Node.AUTO_TRANSLATE_MODE_DISABLED
	return l


static func centered_label(text: String, variation := &"", translate := true) -> Label:
	var l := label(text, variation, translate)
	l.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	l.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	l.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	l.size_flags_vertical = Control.SIZE_EXPAND_FILL
	l.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	return l


## Flutter FatContainer: a background box 7.5 % of the screen height with centered
## text in the button style.
static func fat(text: String, screen_height: float, translate := true, font_size := 0) -> PanelContainer:
	var l := centered_label(text, &"ButtonText", translate)
	if font_size > 0:
		l.add_theme_font_size_override("font_size", font_size)
	return fill(l, screen_height * 0.075)


static func margin(child: Control, left := 0, top := 0, right := 0, bottom := 0) -> MarginContainer:
	var m := MarginContainer.new()
	m.add_theme_constant_override("margin_left", left)
	m.add_theme_constant_override("margin_top", top)
	m.add_theme_constant_override("margin_right", right)
	m.add_theme_constant_override("margin_bottom", bottom)
	m.add_child(child)
	return m


static func margin_all(child: Control, value: int) -> MarginContainer:
	return margin(child, value, value, value, value)


static func spacer(width := 0.0, height := 0.0, expand := false) -> Control:
	var c := Control.new()
	c.custom_minimum_size = Vector2(width, height)
	c.mouse_filter = Control.MOUSE_FILTER_IGNORE
	if expand:
		c.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	return c


static func vbox(children: Array = [], separation := 0) -> VBoxContainer:
	var box := VBoxContainer.new()
	box.add_theme_constant_override("separation", separation)
	for child in children:
		box.add_child(child)
	return box


## Flutter Row(mainAxisAlignment: spaceEvenly).
static func row_space_evenly(children: Array) -> HBoxContainer:
	var box := HBoxContainer.new()
	box.add_theme_constant_override("separation", 0)
	box.add_child(spacer(0, 0, true))
	for child in children:
		box.add_child(child)
		box.add_child(spacer(0, 0, true))
	return box


## Stretches [param control] over its parent. Works before the control enters the
## tree, unlike the anchor presets, which compute offsets from the current size.
static func fill_parent(control: Control) -> Control:
	control.anchor_left = 0.0
	control.anchor_top = 0.0
	control.anchor_right = 1.0
	control.anchor_bottom = 1.0
	control.offset_left = 0.0
	control.offset_top = 0.0
	control.offset_right = 0.0
	control.offset_bottom = 0.0
	return control


## Lets drags reach a scrolling parent through the given subtree.
static func pass_mouse(root: Control) -> void:
	if root.mouse_filter == Control.MOUSE_FILTER_STOP:
		root.mouse_filter = Control.MOUSE_FILTER_PASS
	for child in root.get_children():
		if child is Control:
			pass_mouse(child)
