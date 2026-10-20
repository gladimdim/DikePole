class_name CatalogScreen
extends Control
## Flutter MainMenu: the waiting screen for the first frame (target of the cossack
## Hero), then the story carousel sliding in from 1000 px over 2 s (linearToEaseOut).

const APPEAR_FROM := 1000.0
const APPEAR_DURATION := 2.0

var _content: Control
var _offset := APPEAR_FROM


func _ready() -> void:
	_content = Control.new()
	var back_to_menu: Array[Dictionary] = [{"text": "backtomenu", "action": func() -> void: Router.instance.pop()}]
	add_child(NarrowScaffold.create(_content, "apptitle", back_to_menu, false))

	var waiting := _waiting_view()
	UI.fill_parent(waiting)
	_content.add_child(waiting)
	_preload_pictures()

	# Flutter starts the appearance animation in initState, before the catalog loads.
	FlutterCurves.tween_method(create_tween(), _set_offset, APPEAR_FROM, 0.0, APPEAR_DURATION,
			FlutterCurves.LINEAR_TO_EASE_OUT)

	# The catalog "future" resolves after the first frames, as with the asset bundle.
	await get_tree().process_frame
	await get_tree().process_frame
	waiting.queue_free()
	_content.add_child(_build_catalog())


func _waiting_view() -> Control:
	var heading := UI.label("lookingforheroes", &"")
	heading.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	heading.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	var picture := LandingScreen.cossack_image(2.0)
	picture.fit = StoryImage.Fit.HEIGHT
	picture.fit_height = get_viewport_rect().size.y * 0.5
	return UI.vbox([UI.margin(heading, 0, 10), UI.spacer(0, 50), picture])


func _build_catalog() -> Control:
	var pager := VerticalPager.new()
	UI.fill_parent(pager)
	var screen_height := get_viewport_rect().size.y
	for entry in StoryLibrary.catalog:
		var card := StoryCard.new()
		card.entry = entry
		card.screen_height = screen_height
		card.details_pressed.connect(func() -> void: Router.instance.push(StoryDetailsScreen.create(entry)))
		card.read_pressed.connect(func() -> void: ReaderScreen.open(entry))
		pager.add_page(card)
	var holder := Control.new()
	UI.fill_parent(holder)
	holder.add_child(pager)
	holder.position.x = _offset
	holder.set_meta("appear", true)
	return holder


func _set_offset(value: float) -> void:
	_offset = value
	for child in _content.get_children():
		if child.has_meta("appear"):
			child.position.x = value


## Flutter precached every landing picture when the menu opened.
func _preload_pictures() -> void:
	for path in BackgroundImages.landing_paths():
		ResourceLoader.load_threaded_request(path)
