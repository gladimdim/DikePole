class_name StoryDetailsScreen
extends Control
## Flutter StoryDetailsView (expanded): picture, Read, authors and description.

var entry: Dictionary


static func create(catalog_entry: Dictionary) -> StoryDetailsScreen:
	var screen := StoryDetailsScreen.new()
	screen.entry = catalog_entry
	return screen


func _ready() -> void:
	var back: Array[Dictionary] = [{"text": "labelback", "action": func() -> void: Router.instance.pop()}]
	add_child(NarrowScaffold.create(_build_body(), entry["title"], back, true, false))


func _build_body() -> Control:
	var picture := StoryImage.from_spec(BackgroundImages.card_spec(StoryLibrary.story_id(entry)))
	picture.fit = StoryImage.Fit.HEIGHT
	picture.fit_height = 200.0
	# The Flutter tag used the bare title while the card used "year: title", so this
	# hero never matched and never flew. Kept as-is.
	picture.hero_tag = "CatalogView" + entry["title"]

	var read_label := UI.centered_label("startstory", &"ButtonText")
	var read := UI.bordered(SlideableButton.wrap(UI.fill(read_label, 50), func() -> void: ReaderScreen.open(entry)))

	var authors := HBoxContainer.new()
	authors.custom_minimum_size.y = 30
	authors.add_theme_constant_override("separation", 0)
	authors.add_child(UI.label("authors"))
	authors.add_child(UI.label(entry["author"], &"", false))
	var divider := ColorRect.new()
	divider.custom_minimum_size.y = 2
	divider.color = AppTheme.primary
	AppTheme.changed.connect(func() -> void: if is_instance_valid(divider): divider.color = AppTheme.primary)
	var description := UI.label(entry["description"], &"", false)
	description.add_theme_font_size_override("font_size", 15)
	description.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART

	var scroll := ScrollContainer.new()
	scroll.horizontal_scroll_mode = ScrollContainer.SCROLL_MODE_DISABLED
	scroll.vertical_scroll_mode = ScrollContainer.SCROLL_MODE_SHOW_NEVER
	scroll.size_flags_vertical = Control.SIZE_EXPAND_FILL
	var details := UI.vbox([authors, divider, description])
	details.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	scroll.add_child(UI.margin_all(details, 8))
	(scroll.get_child(0) as Control).size_flags_horizontal = Control.SIZE_EXPAND_FILL

	var column := UI.vbox([UI.margin(picture, 0, 0, 0, 1), read, scroll])
	return UI.margin_all(column, 4)
