extends Node
## Grid of every reveal and ambient mode on one photo, saved as screenshots:
##   godot --path . -- --effects=/some/dir

const PHOTO := "res://images/background/camp/c_5.jpg"


func _ready() -> void:
	var out := ""
	for arg in OS.get_cmdline_user_args():
		if arg.begins_with("--effects="):
			out = arg.trim_prefix("--effects=")
	DirAccess.make_dir_recursive_absolute(out)
	var layer := CanvasLayer.new()
	add_child(layer)
	var grid := GridContainer.new()
	grid.columns = 2
	grid.size = get_viewport().get_visible_rect().size
	grid.add_theme_constant_override("h_separation", 4)
	grid.add_theme_constant_override("v_separation", 4)
	layer.add_child(UI.fill_parent(UI.fill(grid)))

	var reveals := []
	for reveal in [StoryImage.Reveal.SKETCH, StoryImage.Reveal.DEVELOP, StoryImage.Reveal.INK, StoryImage.Reveal.FADE]:
		for at in [0.0, 0.5]:
			reveals.append(_cell(grid, {"to": PHOTO, "reveal": reveal, "duration": 2.0}, at))
	await get_tree().create_timer(0.3).timeout
	for cell in reveals:
		cell[0]._elapsed = cell[1] * 2.0
	# Captures lag a frame behind, so let a few frames render first.
	for i in 3:
		await get_tree().process_frame
	await _shot(out + "/reveals.png")
	await _khotyn_preview(out + "/khotyn_engraving_style.png")

	for child in grid.get_children():
		child.queue_free()
	await get_tree().process_frame
	for ambient in [StoryImage.Ambient.FIRE, StoryImage.Ambient.MIST, StoryImage.Ambient.WATER,
			StoryImage.Ambient.RAIN, StoryImage.Ambient.SNOW, StoryImage.Ambient.SMOKE,
			StoryImage.Ambient.DUST, StoryImage.Ambient.NIGHT]:
		_cell(grid, {"to": PHOTO, "reveal": StoryImage.Reveal.FADE, "duration": 0.01, "ambient": ambient,
				"motion": StoryImage.Motion.PUSH_IN, "focus": Vector2(0.7, 0.4)}, 1.0)
	await get_tree().create_timer(1.5).timeout
	await _shot(out + "/ambients.png")
	get_tree().quit()


func _cell(grid: GridContainer, spec: Dictionary, at: float) -> Array:
	var image := StoryImage.from_spec(spec)
	image.fit = StoryImage.Fit.WIDTH
	image.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	grid.add_child(image)
	return [image, at]


func _shot(path: String) -> void:
	await RenderingServer.frame_post_draw
	get_viewport().get_texture().get_image().save_png(path)


func _khotyn_preview(path: String) -> void:
	# A standalone comparison at phone-like image width, without screen cropping.
	var viewport := SubViewport.new()
	viewport.size = Vector2i(1200, 330)
	viewport.render_target_update_mode = SubViewport.UPDATE_ALWAYS
	add_child(viewport)
	var sheet := ColorRect.new()
	sheet.color = Color("ede8db")
	sheet.size = Vector2(1200, 330)
	viewport.add_child(sheet)
	var titles := ["Original drawing", "New drawing", "Photographic cover"]
	var files := ["r_n9.png", "r.0_n0.png", "cover.png"]
	for i in 3:
		var label := Label.new()
		label.text = titles[i]
		label.position = Vector2(i * 400 + 12, 3)
		label.add_theme_color_override("font_color", Color("302b24"))
		viewport.add_child(label)
		var picture := StoryImage.from_spec({"to": "res://images/stories/hotinska_riznya/" + files[i],
				"reveal": StoryImage.Reveal.FADE if i == 2 else StoryImage.Reveal.INK, "duration": 3.2})
		picture.position = Vector2(i * 400, 30)
		picture.size = Vector2(400, 300)
		viewport.add_child(picture)
		picture.set_process(false)
		picture.progress = 1.0
	for i in 3:
		await RenderingServer.frame_post_draw
	viewport.get_texture().get_image().save_png(path)
	viewport.queue_free()
