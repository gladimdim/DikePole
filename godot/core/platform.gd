extends Node
## Device services used by the reader: haptics, external links, safe area.


## Flutter HapticFeedback.lightImpact: pressing Next.
func haptic_light() -> void:
	if OS.has_feature("mobile") and AppPrefs.haptics:
		Input.vibrate_handheld(10, 0.35)


## Flutter HapticFeedback.mediumImpact: picking a choice.
func haptic_medium() -> void:
	if OS.has_feature("mobile") and AppPrefs.haptics:
		Input.vibrate_handheld(20, 0.6)


func open_url(url: String) -> void:
	OS.shell_open(url)


## Insets of notches/home indicator in canvas units: left, top, right, bottom.
func safe_area_insets(viewport: Viewport) -> Vector4:
	var screen := DisplayServer.screen_get_size()
	var safe := DisplayServer.get_display_safe_area()
	if screen.x <= 0 or safe.size.x <= 0:
		return Vector4.ZERO
	var scale := viewport.get_visible_rect().size / Vector2(screen)
	return Vector4(safe.position.x * scale.x, safe.position.y * scale.y,
			(screen.x - safe.end.x) * scale.x, (screen.y - safe.end.y) * scale.y)
