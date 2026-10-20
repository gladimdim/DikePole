extends Node
## Themes of the app, switchable at runtime.
##
## [member background]/[member primary] are the black-and-white colors of the Flutter
## design (story view, classic screens). The other colors and the label variations
## Caps…PrimaryText belong to the thin design of the home and story screens.

signal changed

const APP_BAR_HEIGHT := 40.0
const BORDER := 3
const BODY_SIZE := 18

const FONT_BODY := preload("res://ui/fonts/Raleway-Bold.ttf")
const FONT_REGULAR := preload("res://ui/fonts/Roboto-Regular.ttf")
const FONT_BOLD := preload("res://ui/fonts/Roboto-Bold.ttf")
const RALEWAY_LIGHT := preload("res://ui/fonts/Raleway-Light.ttf")
const RALEWAY_REGULAR := preload("res://ui/fonts/Raleway-Regular.ttf")
const RALEWAY_MEDIUM := preload("res://ui/fonts/Raleway-Medium.ttf")
const RALEWAY_SEMIBOLD := preload("res://ui/fonts/Raleway-SemiBold.ttf")

var theme: Theme
var dark := false
var background: Color
var primary: Color
## Flutter only bundled Roboto Regular, so its "bold" headlines were synthetic.
var font_headline: FontVariation

# Thin design palette.
var paper: Color      ## screen background
var surface: Color    ## raised areas (sheet, buttons in rest state)
var ink: Color        ## main text
var ink_soft: Color   ## secondary text
var hairline: Color   ## 1 px separators and outlines
var accent: Color     ## crimson: years, progress, primary button
var on_accent: Color  ## text on the accent

var _caps_font: FontVariation
var _wordmark_font: FontVariation


func _ready() -> void:
	font_headline = FontVariation.new()
	font_headline.base_font = FONT_REGULAR
	font_headline.variation_embolden = 0.6
	_caps_font = FontVariation.new()
	_caps_font.base_font = RALEWAY_SEMIBOLD
	_caps_font.spacing_glyph = 1
	_wordmark_font = FontVariation.new()
	_wordmark_font.base_font = RALEWAY_MEDIUM
	_wordmark_font.spacing_glyph = 4
	_build()
	AppPrefs.changed.connect(_on_pref_changed)


func set_dark(value: bool) -> void:
	AppPrefs.dark_theme = value


func set_mode(mode: String) -> void:
	AppPrefs.theme_mode = mode


func _notification(what: int) -> void:
	# The device theme may have changed while the app was in the background.
	if what == NOTIFICATION_APPLICATION_FOCUS_IN and theme and AppPrefs.theme_mode == "system" \
			and AppPrefs.dark_theme != dark:
		_rebuild()


func _on_pref_changed(key: String) -> void:
	if key in ["themeMode", "isDarkTheme", "textScale"]:
		_rebuild()


func _rebuild() -> void:
	_build()
	changed.emit()


func _build() -> void:
	dark = AppPrefs.dark_theme
	background = Color.BLACK if dark else Color.WHITE
	primary = Color.WHITE if dark else Color.BLACK
	if dark:
		paper = Color("#121211")
		surface = Color("#1c1b19")
		ink = Color("#ecEAE4")
		ink_soft = Color("#9a978f")
		hairline = Color("#2c2b28")
		accent = Color("#e0625a")
		on_accent = Color("#121211")
	else:
		paper = Color("#faf9f6")
		surface = Color("#f1efea")
		ink = Color("#1b1a18")
		ink_soft = Color("#77736b")
		hairline = Color("#e2dfd8")
		accent = Color("#a4282c")
		on_accent = Color("#ffffff")

	if theme == null:
		theme = Theme.new()
	var t := theme
	# Flutter's bodyText2 (default text): Raleway-Bold 18, scaled by the reader's choice.
	t.default_font = FONT_BODY
	t.default_font_size = roundi(BODY_SIZE * AppPrefs.text_scale)
	t.set_color("font_color", "Label", primary)
	t.set_constant("line_spacing", "Label", 3)
	_label_variation(t, "Headline", font_headline, 20, primary)
	_label_variation(t, "ButtonText", FONT_BOLD, 20, primary)
	_label_variation(t, "SmallBold", FONT_BOLD, 15, primary)
	_label_variation(t, "Plain", FONT_REGULAR, 15, primary)

	_label_variation(t, "Wordmark", _wordmark_font, 14, ink)
	_label_variation(t, "Caps", _caps_font, 12, accent)
	_label_variation(t, "Display", RALEWAY_LIGHT, 30, ink, 2)
	_label_variation(t, "H2", RALEWAY_SEMIBOLD, 21, ink)
	_label_variation(t, "Title", RALEWAY_SEMIBOLD, 17, ink, 1)
	_label_variation(t, "Body", RALEWAY_REGULAR, 15, ink, 7)
	_label_variation(t, "Meta", RALEWAY_MEDIUM, 13, ink_soft)
	_label_variation(t, "Stat", RALEWAY_LIGHT, 24, ink)
	_label_variation(t, "PrimaryText", RALEWAY_SEMIBOLD, 16, on_accent)
	_label_variation(t, "ButtonQuiet", RALEWAY_SEMIBOLD, 15, ink)
	_label_variation(t, "OnImage", RALEWAY_SEMIBOLD, 22, Color.WHITE, 1)
	_label_variation(t, "OnImageCaps", _caps_font, 11, Color(1, 1, 1, 0.85))

	t.set_stylebox("panel", "Bordered", _box(true))
	t.set_type_variation("Bordered", "PanelContainer")
	t.set_stylebox("panel", "Fill", _box(false))
	t.set_type_variation("Fill", "PanelContainer")
	t.set_stylebox("panel", "PanelContainer", StyleBoxEmpty.new())
	t.set_stylebox("panel", "Paper", flat(paper))
	t.set_type_variation("Paper", "PanelContainer")


## Rounded flat box, optionally outlined with a hairline.
func flat(color: Color, radius := 0, outline := Color.TRANSPARENT, padding := 0) -> StyleBoxFlat:
	var box := StyleBoxFlat.new()
	box.bg_color = color
	box.set_corner_radius_all(radius)
	box.anti_aliasing = radius > 0
	if outline.a > 0.0:
		box.set_border_width_all(1)
		box.border_color = outline
	box.set_content_margin_all(padding)
	return box


func _label_variation(t: Theme, name: StringName, font: Font, font_size: int, color: Color, line_spacing := 3) -> void:
	t.set_type_variation(name, "Label")
	t.set_font("font", name, font)
	t.set_font_size("font_size", name, font_size)
	t.set_color("font_color", name, color)
	t.set_constant("line_spacing", name, line_spacing)


func _box(bordered: bool) -> StyleBoxFlat:
	var box := StyleBoxFlat.new()
	box.bg_color = background
	if bordered:
		box.set_border_width_all(BORDER)
		box.border_color = primary
	return box
