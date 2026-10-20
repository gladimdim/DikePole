class_name LandingScreen
extends Control
## Flutter LoginView: site link, version, the cossack picture, Start and language.

const SITE_URL := "https://locadeserta.com/"
const HERO_TAG := "CossackHero"
const COSSACK_PHOTO := "res://images/background/c_cossack_0.jpg"
const COSSACK_SKETCH := "res://images/background/cossack_0.jpg"

var _version: Label
var _radios := {}


## The cossack picture of the landing and waiting screens (photo fades to sketch).
static func cossack_image(duration: float) -> StoryImage:
	var image := StoryImage.from_spec({"from": COSSACK_PHOTO, "to": COSSACK_SKETCH, "classic": true, "duration": duration})
	image.hero_tag = HERO_TAG
	image.corner_radius = 20.0
	return image


func _ready() -> void:
	var actions: Array[Dictionary] = [
		{"text": func() -> String: return "lightThemeLabel" if AppPrefs.dark_theme else "darkThemeLabel",
			"action": func() -> void: AppTheme.set_dark(not AppPrefs.dark_theme)},
		{"text": func() -> String: return "classicAnimationsOn" if AppPrefs.classic_look else "classicAnimationsOff",
			"action": func() -> void: AppPrefs.classic_look = not AppPrefs.classic_look},
	]
	add_child(NarrowScaffold.create(_build_body(), "apptitle", actions, false))


func _notification(what: int) -> void:
	if what == NOTIFICATION_TRANSLATION_CHANGED and _version:
		_version.text = "%s: %s" % [tr("version"), ProjectSettings.get_setting("application/config/version")]


func _build_body() -> Control:
	var link := LinkButton.new()
	link.text = "labelSiteLink"
	link.underline = LinkButton.UNDERLINE_MODE_ALWAYS
	link.add_theme_font_override("font", AppTheme.FONT_BOLD)
	link.add_theme_font_size_override("font_size", 15)
	link.pressed.connect(Platform.open_url.bind(SITE_URL))
	_style_link(link)
	AppTheme.changed.connect(_style_link.bind(link))
	_version = UI.label("", &"SmallBold", false)
	notification(NOTIFICATION_TRANSLATION_CHANGED)

	var picture := cossack_image(4.0)
	picture.fit = StoryImage.Fit.CONTAIN
	picture.size_flags_vertical = Control.SIZE_EXPAND_FILL
	var picture_box := UI.margin(picture, 0, 10)
	picture_box.size_flags_vertical = Control.SIZE_EXPAND_FILL

	var start := SlideableButton.wrap(UI.bordered(UI.fill(UI.centered_label("start", &"ButtonText"), 50)),
			func() -> void: Router.instance.push(CatalogScreen.new()))

	return UI.vbox([
		UI.margin(UI.row_space_evenly([link, _version]), 0, 8),
		picture_box,
		UI.spacer(0, 20),
		start,
		_build_locale_selection(),
	])


func _style_link(link: LinkButton) -> void:
	for state in ["font_color", "font_hover_color", "font_pressed_color", "font_focus_color"]:
		link.add_theme_color_override(state, AppTheme.primary)


func _build_locale_selection() -> Control:
	var row := HBoxContainer.new()
	row.alignment = BoxContainer.ALIGNMENT_CENTER
	row.add_theme_constant_override("separation", 0)
	for option in [["uk", "UA"], ["en", "ENG"]]:
		var radio := RadioDot.new()
		radio.checked = AppPrefs.language == option[0]
		radio.selected.connect(_set_language.bind(option[0]))
		_radios[option[0]] = radio
		var label := UI.label(option[1], &"", false)
		label.size_flags_vertical = Control.SIZE_SHRINK_CENTER
		row.add_child(radio)
		row.add_child(label)
	return row


func _set_language(code: String) -> void:
	AppPrefs.language = code
	TranslationServer.set_locale(code)
	for key in _radios:
		_radios[key].checked = key == code
