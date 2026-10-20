class_name NarrowScaffold
extends Control
## Flutter NarrowScaffold + AppBarCustom: a bordered bar with back arrow, title and a
## "Menu ▾" that expands into a list of actions over a blurred scrim.

const BLUR_SHADER := preload("res://ui/components/backdrop_blur.gdshader")
const ITEM_HEIGHT := 50.0
const BAR_INNER_HEIGHT := 40.0
const TOP_PADDING := 8

var body: Control
## Each action: {"text": translation key, "action": Callable}.
var actions: Array[Dictionary] = []
var title := ""
var translate_title := true
var show_back := true

var _expanded := false
var _scrim: ColorRect
var _items: VBoxContainer
var _menu_glyph: Glyph


static func create(screen_body: Control, screen_title: String, screen_actions: Array[Dictionary],
		back := true, translate := true) -> NarrowScaffold:
	var scaffold := NarrowScaffold.new()
	scaffold.body = screen_body
	scaffold.title = screen_title
	scaffold.actions = screen_actions
	scaffold.show_back = back
	scaffold.translate_title = translate
	return scaffold


func _ready() -> void:
	UI.fill_parent(self)
	var background := UI.fill()
	UI.fill_parent(background)
	background.mouse_filter = Control.MOUSE_FILTER_IGNORE
	add_child(background)

	var holder := Control.new()
	UI.fill_parent(holder)
	holder.offset_top = AppTheme.APP_BAR_HEIGHT + 8
	holder.mouse_filter = Control.MOUSE_FILTER_IGNORE
	add_child(holder)
	UI.fill_parent(body)
	holder.add_child(body)

	_scrim = ColorRect.new()
	UI.fill_parent(_scrim)
	var blur := ShaderMaterial.new()
	blur.shader = BLUR_SHADER
	_scrim.material = blur
	_scrim.visible = false
	_scrim.gui_input.connect(func(event: InputEvent) -> void:
		if event is InputEventMouseButton and not event.pressed:
			_set_expanded(false))
	add_child(_scrim)

	add_child(_build_bar())


func _build_bar() -> Control:
	var row := HBoxContainer.new()
	row.custom_minimum_size.y = BAR_INNER_HEIGHT - TOP_PADDING
	row.add_theme_constant_override("separation", 0)
	if show_back:
		var back := UI.margin(Glyph.create(Glyph.Kind.ARROW_BACK), 10)
		back.size_flags_vertical = Control.SIZE_SHRINK_BEGIN
		back.gui_input.connect(func(event: InputEvent) -> void:
			if event is InputEventMouseButton and not event.pressed:
				Router.instance.pop())
		row.add_child(back)
	var title_label := UI.label(title, &"Headline", translate_title)
	title_label.clip_text = true
	title_label.text_overrun_behavior = TextServer.OVERRUN_TRIM_ELLIPSIS
	title_label.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	title_label.size_flags_vertical = Control.SIZE_SHRINK_BEGIN
	var title_box := UI.margin(title_label, 10)
	title_box.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	row.add_child(title_box)
	if not actions.is_empty():
		var menu := HBoxContainer.new()
		menu.add_theme_constant_override("separation", 0)
		menu.size_flags_vertical = Control.SIZE_SHRINK_BEGIN
		menu.mouse_filter = Control.MOUSE_FILTER_STOP
		menu.add_child(UI.label("menu"))
		_menu_glyph = Glyph.create(Glyph.Kind.DROP_DOWN)
		menu.add_child(_menu_glyph)
		menu.gui_input.connect(func(event: InputEvent) -> void:
			if event is InputEventMouseButton and not event.pressed:
				_set_expanded(not _expanded))
		row.add_child(menu)

	_items = UI.vbox()
	_items.visible = false

	var bar := UI.bordered(UI.margin(UI.vbox([row, _items]), 0, TOP_PADDING))
	bar.set_anchors_and_offsets_preset(Control.PRESET_TOP_WIDE)
	return bar


## "text" may be a Callable returning the key, for labels that change (theme toggle).
func _menu_item(item: Dictionary) -> Control:
	var key: String = item["text"].call() if item["text"] is Callable else item["text"]
	var text := UI.centered_label(key, &"ButtonText")
	text.custom_minimum_size.y = ITEM_HEIGHT
	text.mouse_filter = Control.MOUSE_FILTER_STOP
	text.gui_input.connect(func(event: InputEvent) -> void:
		if event is InputEventMouseButton and not event.pressed:
			_set_expanded(false)
			item["action"].call())
	return text


func _set_expanded(value: bool) -> void:
	_expanded = value
	for child in _items.get_children():
		child.queue_free()
	if value:
		for item in actions:
			_items.add_child(_menu_item(item))
	_items.visible = value
	_scrim.visible = value
	_menu_glyph.kind = Glyph.Kind.DROP_UP if value else Glyph.Kind.DROP_DOWN
	var scale := get_viewport().get_final_transform().get_scale().x
	(_scrim.material as ShaderMaterial).set_shader_parameter("sigma", 1.5 * scale)
