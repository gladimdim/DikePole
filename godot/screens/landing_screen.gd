class_name LandingScreen
extends Control
## Flutter LoginView: version, the cossack picture and Start.

const HERO_TAG := "CossackHero"
const COSSACK_PHOTO := "res://images/background/c_cossack_0.jpg"
const COSSACK_SKETCH := "res://images/background/cossack_0.jpg"

var _version: Label


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
	]
	add_child(NarrowScaffold.create(_build_body(), "apptitle", actions, false))


func _notification(what: int) -> void:
	if what == NOTIFICATION_TRANSLATION_CHANGED and _version:
		_version.text = "%s: %s" % [tr("version"), ProjectSettings.get_setting("application/config/version")]


func _build_body() -> Control:
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
		UI.margin(UI.row_space_evenly([_version]), 0, 8),
		picture_box,
		UI.spacer(0, 20),
		start,
		UI.spacer(0, 20),
	])

