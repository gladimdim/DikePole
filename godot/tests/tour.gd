extends Node
## Scripted walk through the app that saves screenshots, for visual checks:
##   godot --path . -- --tour=/some/dir [--classic] [--dark]

var _out := ""
var _count := 0


func _ready() -> void:
	for arg in OS.get_cmdline_user_args():
		if arg.begins_with("--tour="):
			_out = arg.trim_prefix("--tour=")
	DirAccess.make_dir_recursive_absolute(_out)
	AppPrefs.theme_mode = "dark" if "--dark" in OS.get_cmdline_user_args() else "light"
	if "--classic" in OS.get_cmdline_user_args():
		AppPrefs.classic_look = true
		await get_tree().process_frame
		_run()
	else:
		AppPrefs.classic_look = false
		_prepare_progress()
		Router.instance.reset_to(HomeScreen.new())
		_run_home()


## Seeds realistic state: one story half read, one finished with an ending found.
func _prepare_progress() -> void:
	for file in DirAccess.get_files_at(AppPrefs.SAVES_DIR):
		DirAccess.remove_absolute("%s/%s" % [AppPrefs.SAVES_DIR, file])
	AppPrefs._values.erase("endings")
	var reading := _entry("kodak_night")
	var story := StoryLibrary.reopen_from_start(reading)
	for i in 60:
		if story.can_continue():
			story.do_continue()
	StoryLibrary.save(story)
	var finished := StoryLibrary.reopen_from_start(_entry("hunting_bears"))
	while true:
		while finished.can_continue():
			finished.do_continue()
		if not finished.current_page.has_next():
			break
		finished.go_to_next_page_by_index(finished.current_page.next.size() - 1)
	StoryLibrary.save(finished)


func _entry(id: String) -> Dictionary:
	for entry in StoryLibrary.catalog:
		if StoryLibrary.story_id(entry) == id:
			return entry
	return {}


func _run_home() -> void:
	await _wait(1.2)
	await _shot("home")
	var home: HomeScreen = Router.instance.top()
	home._scroll.scroll_vertical = 520
	await _wait(0.5)
	await _shot("home_scrolled")
	home._set_filter(HomeScreen.Filter.READING)
	await _wait(0.6)
	await _shot("home_filter_reading")
	home._set_filter(HomeScreen.Filter.ALL)
	home._scroll.scroll_vertical = 0
	await _wait(0.4)
	home._open_settings()
	await _wait(0.6)
	await _shot("settings")
	home.handle_back()
	await _wait(0.5)

	Router.instance.push(StoryScreen.create(_entry("kodak_night")))
	await _wait(0.12)
	await _shot("story_hero_flight")
	await _wait(1.0)
	await _shot("story_reveal")
	await _wait(2.5)
	await _shot("story")
	var story_screen: Control = Router.instance.top()
	var scroll: ScrollContainer = _find(story_screen, ScrollContainer)
	scroll.scroll_vertical = 2000
	await _wait(0.4)
	await _shot("story_endings")
	Router.instance.pop()
	await _wait(0.6)
	Router.instance.push(StoryScreen.create(_entry("hunting_bears")))
	await _wait(1.5)
	await _shot("story_finished")
	Router.instance.pop()
	await _wait(0.6)

	AppPrefs.theme_mode = "dark"
	await _wait(1.0)
	await _shot("home_dark")
	Router.instance.push(StoryScreen.create(_entry("ostannij")))
	await _wait(3.0)
	await _shot("story_dark_new")
	AppPrefs.theme_mode = "light"
	get_tree().quit()


func _run() -> void:
	await _wait(0.4)
	await _shot("landing_start")
	await _wait(4.0)
	await _shot("landing_after_fade")

	Router.instance.push(CatalogScreen.new())
	await _wait(0.12)
	await _shot("hero_flight_mid")
	await _wait(0.6)
	await _shot("catalog_sliding_in")
	await _wait(2.0)
	await _shot("catalog")
	var pager: VerticalPager = _find(Router.instance.top(), VerticalPager)
	pager._set_page(0.35)
	await _shot("catalog_page_0_35")
	pager._set_page(0.75)
	await _shot("catalog_page_0_75_collapsed")
	pager._set_page(0.0)

	Router.instance.push(StoryDetailsScreen.create(StoryLibrary.catalog[1]))
	await _wait(1.0)
	await _shot("details")
	Router.instance.pop()
	await _wait(0.5)

	_clear_save(StoryLibrary.catalog[6])
	ReaderScreen.open(StoryLibrary.catalog[6])
	await _wait(0.15)
	await _shot("reader_slide_in")
	await _wait(1.5)
	await _shot("reader_first")
	var reader: ReaderScreen = Router.instance.top()
	for i in 3:
		reader._on_next()
		await _wait(0.5)
	await _shot("reader_after_next_reveal")
	await _wait(3.0)
	await _shot("reader_after_next_done")
	while reader.story.can_continue():
		reader._on_next()
		await _wait(0.05)
	await _wait(1.0)
	await _shot("reader_choices")
	reader._on_choice(0)
	await _wait(1.0)
	while reader.story.can_continue():
		reader._on_next()
		await _wait(0.05)
	await _wait(1.0)
	await _shot("reader_end")

	var scaffold: NarrowScaffold = _find(reader, NarrowScaffold)
	scaffold._set_expanded(true)
	await _wait(0.2)
	await _shot("reader_menu")
	scaffold._set_expanded(false)
	get_tree().quit()


func _clear_save(entry: Dictionary) -> void:
	DirAccess.remove_absolute("user://saves/%s.json" % StoryLibrary.story_id(entry))


func _wait(seconds: float) -> void:
	await get_tree().create_timer(seconds).timeout


func _shot(name: String) -> void:
	await RenderingServer.frame_post_draw
	_count += 1
	var path := "%s/%02d_%s.png" % [_out, _count, name]
	get_viewport().get_texture().get_image().save_png(path)


func _find(root: Node, type: Variant) -> Node:
	for child in root.get_children():
		if is_instance_of(child, type):
			return child
		var found := _find(child, type)
		if found:
			return found
	return null
