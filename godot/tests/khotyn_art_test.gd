extends SceneTree
## Complete Khotyn artwork, saved-passage resolution, and animation lifecycle.
## godot --headless --path . -s tests/khotyn_art_test.gd

var _failures := 0
var _checks := 0


func _init() -> void:
	_run.call_deferred()


func _check(ok: bool, message: String) -> void:
	_checks += 1
	if not ok:
		_failures += 1
		push_error(message)


func _run() -> void:
	# Load after autoloads exist: a custom SceneTree is compiled before AppTheme.
	var image_script = load("res://anim/story_image.gd")
	var backgrounds := root.get_node("BackgroundImages")
	var prefs := root.get_node("AppPrefs")
	var original_classic: bool = prefs.classic_look
	# Set the in-memory flag only; never write the person's preferences or saves.
	prefs.classic_look = false
	var manifest: Dictionary = JSON.parse_string(FileAccess.get_file_as_string("res://images/manifest.json"))
	var count := 0
	var old_paths := PackedStringArray(["res://images/background/camp/c_0.jpg", "res://images/background/camp/0.jpg"])
	var entries := FileAccess.get_file_as_string("res://art/prompts/hotinska_riznya.jsonl")
	for line in entries.split("\n", false):
		var entry: Dictionary = JSON.parse_string(line)
		var id: String = entry["id"]
		var path: String = "res://" + entry["file"]
		_check(ResourceLoader.exists(path), "Missing bundled image: " + path)
		var texture := load(path) as Texture2D
		_check(texture != null, "Cannot load image: " + path)
		if texture:
			_check(absf(texture.get_size().aspect() - 4.0 / 3.0) < 0.02, "Image must be landscape 4:3: " + path)
		if id.ends_with("/cover"):
			_check(manifest["covers"].get("hotinska_riznya", {}).get("image") == path, "Cover is indexed")
			_check(manifest["covers"]["hotinska_riznya"]["reveal"] == "fade", "Photographic cover stays full color")
			continue
		count += 1
		_check(manifest["nodes"].get(id, {}).get("image") == path, "Passage is indexed: " + id)
		var spec: Dictionary = backgrounds.passage_spec(old_paths, id)
		_check(spec.get("to") == path, "Saved pool photos resolve to the new art: " + id)
		_check(spec["reveal"] == image_script.Reveal.INK and spec["duration"] == 3.2,
				"Every illustration uses the original ink reveal, without a pencil filter: " + id)
		_check(spec["motion"] == image_script.Motion.STATIC and spec["ambient"] == image_script.Ambient.NONE,
				"Finished drawing must be still: " + id)
	_check(count == 32, "Expected all 32 illustrated passages")
	var sample_spec: Dictionary = backgrounds.passage_spec(old_paths, "hotinska_riznya/r.0/0")
	var picture = image_script.from_spec(sample_spec)
	root.add_child(picture)
	picture._process(3.2)
	_check(picture.progress == 1.0 and not picture.is_processing(), "Finished drawing stops its animation updates")
	picture.restart()
	_check(picture.progress == 0.0 and picture.is_processing(), "Restart resumes the ink reveal")
	picture.free()
	prefs.classic_look = true
	var classic: Dictionary = backgrounds.passage_spec(old_paths, "hotinska_riznya/r.0/0")
	_check(classic.get("classic", false) and classic["to"] == old_paths[1], "Classic reader retains its original sketch pair")
	prefs.classic_look = original_classic
	print("Khotyn art: %d checks, %d failures" % [_checks, _failures])
	quit(_failures)
