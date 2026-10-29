extends Node
## Run with an isolated XDG_DATA_HOME and --resolution 1080x2160.
## godot --path godot tools/capture_store.tscn -- --out=/absolute/path
var out := ""

func _ready() -> void:
	_run.call_deferred()

func _entry(id: String) -> Dictionary:
	for entry in StoryLibrary.catalog:
		if StoryLibrary.story_id(entry) == id:
			return entry
	return {}

func _wait(seconds := 1.0) -> void:
	await get_tree().create_timer(seconds).timeout

func _shot(name: String) -> void:
	await RenderingServer.frame_post_draw
	var result := get_viewport().get_texture().get_image().save_png(out.path_join(name + ".png"))
	assert(result == OK)
	print("Captured ", name)

func _run() -> void:
	for arg in OS.get_cmdline_user_args():
		if arg.begins_with("--out="):
			out = arg.trim_prefix("--out=")
	assert(not out.is_empty())
	DirAccess.make_dir_recursive_absolute(out)
	AppPrefs.theme_mode = "light"
	AppPrefs.classic_look = false

	await _wait(4.0)
	await _shot("1_home")
	Router.instance.push(StoryScreen.create(_entry("last_battle_at_berestechko")))
	await _wait(4.0)
	await _shot("2_story_details")
	ReaderScreen.open(_entry("krivava_pastka"), true)
	await _wait(4.0)
	var reader: ReaderScreen = Router.instance.top()
	reader._finish_writing()
	await _wait()
	await _shot("3_reader_illustration")
	while reader.story.can_continue():
		reader._finish_writing()
		reader._on_next()
		await _wait(0.1)
	reader._finish_writing()
	await _wait(4.0)
	await _shot("4_choice")
	var steps := 0
	while not reader.story.is_the_end() and steps < 300:
		reader._finish_writing()
		if reader.story.can_continue():
			reader._on_next()
		elif reader.story.current_page.has_next():
			reader._on_choice(0)
		else:
			break
		steps += 1
		await _wait(0.1)
	reader._finish_writing()
	await _wait(4.0)
	await _shot("5_ending")
	Router.instance.reset_to(HomeScreen.new())
	await _wait(2.0)
	var home: HomeScreen = Router.instance.top()
	home._scroll.scroll_vertical = 1250
	await _wait(4.0)
	await _shot("6_story_list")
	get_tree().quit()
