extends Control
## App root: theme, safe area, screen router, hero overlay, Android back button.

var _router: Router
var _safe: MarginContainer
var _background: ColorRect


func _ready() -> void:
	theme = AppTheme.theme
	TranslationServer.set_locale("uk")

	# Shows behind the notch / status bar area too.
	_background = ColorRect.new()
	UI.fill_parent(_background)
	add_child(_background)
	_paint_background()
	AppTheme.changed.connect(_paint_background)

	_safe = MarginContainer.new()
	UI.fill_parent(_safe)
	add_child(_safe)
	_router = Router.new()
	_safe.add_child(_router)

	var hero_layer := Control.new()
	UI.fill_parent(hero_layer)
	hero_layer.mouse_filter = Control.MOUSE_FILTER_IGNORE
	add_child(hero_layer)
	_router.hero_layer = hero_layer

	get_viewport().size_changed.connect(_apply_safe_area)
	_apply_safe_area()
	_router.push(_root_screen(), Router.Transition.NONE)
	AppPrefs.changed.connect(_on_pref_changed)
	for arg in OS.get_cmdline_user_args():
		if arg == "--input-test":
			add_child(load("res://tests/input_test.gd").new())
		elif arg.begins_with("--tour="):
			add_child(load("res://tests/tour.gd").new())
		elif arg.begins_with("--effects="):
			add_child(load("res://tests/effects_preview.gd").new())


func _notification(what: int) -> void:
	if what == NOTIFICATION_WM_GO_BACK_REQUEST and _router and not _router.pop():
		get_tree().quit()


## The thin design's home, or the original Flutter screens with the classic look.
func _root_screen() -> Control:
	return LandingScreen.new() if AppPrefs.classic_look else HomeScreen.new()


func _on_pref_changed(key: String) -> void:
	if key == "classicLook":
		_paint_background()
		_router.reset_to(_root_screen())


func _paint_background() -> void:
	_background.color = AppTheme.background if AppPrefs.classic_look else AppTheme.paper


## Flutter SafeArea: keep content clear of notches and the home indicator.
func _apply_safe_area() -> void:
	var insets := Platform.safe_area_insets(get_viewport())
	_safe.add_theme_constant_override("margin_left", int(insets.x))
	_safe.add_theme_constant_override("margin_top", int(insets.y))
	_safe.add_theme_constant_override("margin_right", int(insets.z))
	_safe.add_theme_constant_override("margin_bottom", int(insets.w))
