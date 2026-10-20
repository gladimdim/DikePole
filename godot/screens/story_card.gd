class_name StoryCard
extends Control
## One catalog page: Flutter TransformingPageView._buildStoryShell + RevolverShell.
## Normal layout: title, picture, [More details | Read]. When scrolled more than
## half a page past (0.5 < value <= 1) it collapses to picture @ 1 - v over
## title @ v; the layouts cross-fade in 100 ms (AnimatedSwitcher).

signal details_pressed
signal read_pressed

const SWITCH_DURATION := 0.1

var entry: Dictionary
var screen_height := 915.0

var _full: Control
var _collapsed: Control
var _collapsed_picture: StoryImage
var _collapsed_title: Control
var _picture: StoryImage
var _is_collapsed := false
var _switch: Tween


func _ready() -> void:
	var title_text := "%s: %s" % [entry["year"], entry["title"]]
	var spec := BackgroundImages.card_spec(StoryLibrary.story_id(entry))
	_picture = _make_picture(spec, title_text)
	var buttons := HBoxContainer.new()
	buttons.add_theme_constant_override("separation", 0)
	var details := SlideableButton.wrap(UI.bordered(_button_label("showstorydetails")), details_pressed.emit)
	details.size_flags_stretch_ratio = 10
	var read := SlideableButton.wrap(UI.bordered(_button_label("startstory")), read_pressed.emit)
	read.size_flags_stretch_ratio = 10
	var gap := UI.fill(null, 50)
	gap.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	buttons.add_child(details)
	buttons.add_child(gap)
	buttons.add_child(read)

	var picture_box := UI.margin(_picture, 0, 0, 0, 1)
	_full = UI.vbox([_title(title_text), UI.spacer(0, 0), picture_box, UI.spacer(0, 0), buttons])
	(_full.get_child(1) as Control).size_flags_vertical = Control.SIZE_EXPAND_FILL
	(_full.get_child(3) as Control).size_flags_vertical = Control.SIZE_EXPAND_FILL

	_collapsed_picture = _make_picture(spec, "")
	_collapsed_title = _title(title_text)
	var top_space := UI.spacer()
	top_space.size_flags_vertical = Control.SIZE_EXPAND_FILL
	_collapsed = UI.vbox([top_space, _collapsed_picture, _collapsed_title])
	_collapsed.visible = false

	var shell := Control.new()
	shell.add_child(_full)
	shell.add_child(_collapsed)
	for layout in [_full, _collapsed]:
		UI.fill_parent(layout)
	var card := UI.bordered(shell)
	add_child(UI.margin_all(card, 8))
	UI.fill_parent(get_child(0) as Control)


## Called by VerticalPager with currentPage - index.
func set_scroll_value(value: float) -> void:
	var collapse := value > 0.5 and value <= 1.0
	if collapse:
		_collapsed_picture.modulate.a = 1.0 - value
		_collapsed_title.modulate.a = value
	if collapse == _is_collapsed:
		return
	_is_collapsed = collapse
	_collapsed_picture.sync_with(_picture)
	var showing := _collapsed if collapse else _full
	var hiding := _full if collapse else _collapsed
	showing.visible = true
	if _switch:
		_switch.kill()
	_switch = create_tween().set_parallel()
	_switch.tween_property(showing, "modulate:a", 1.0, SWITCH_DURATION).from(0.0)
	_switch.tween_property(hiding, "modulate:a", 0.0, SWITCH_DURATION)
	_switch.chain().tween_callback(func() -> void: hiding.visible = false)


func _make_picture(spec: Dictionary, tag: String) -> StoryImage:
	var picture := StoryImage.from_spec(spec)
	picture.fit = StoryImage.Fit.HEIGHT
	picture.fit_height = screen_height / 3.0
	picture.hero_tag = "CatalogView" + tag if tag != "" else ""
	return picture


func _title(text: String) -> Control:
	var label := UI.centered_label(text, &"Headline", false)
	label.add_theme_font_size_override("font_size", 28)
	return UI.bordered(UI.fill(label, 75))


func _button_label(key: String) -> Control:
	var label := UI.centered_label(key, &"ButtonText")
	label.add_theme_font_size_override("font_size", 22)
	return UI.fill(label, 50)
