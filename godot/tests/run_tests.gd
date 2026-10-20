extends SceneTree
## Engine tests: godot --headless --path . -s tests/run_tests.gd
## Exit code is the number of failures.

const STORIES_DIR := "res://assets/stories"
const PROMPTS_DIR := "res://art/prompts"
const SAMPLE := '{"title":"After the Battle","description":"At the beginning of the XVII century...","authors":"Dmytro Gladkyi, Someone else","year":1648,"root":{"endType":null,"nodes":[{"text":"Dmytro lay hidden in the thicket far from the water","imageType":"river"},{"text":"The Cossack lay like this for a long time."}],"next":[{"text":"Shoot the rifle","nextPage":{}},{"text":"Run away","nextPage":{"nodes":[{"text":"inner"}],"next":[],"endType":"ALIVE"}}]}}'

var _failures := 0
var _checks := 0


func _init() -> void:
	_test_from_json()
	_test_navigation()
	_test_reset()
	_test_steppe()
	_test_save_restore_sample()
	_test_all_stories()
	print("%d checks, %d failures" % [_checks, _failures])
	quit(_failures)


func _resolver(type: GsImageType.Type, node_id: String) -> PackedStringArray:
	return PackedStringArray(["photo:%s" % GsImageType.to_name(type), "sketch:" + node_id])


func _sample() -> GsStory:
	return GsStory.from_dict(JSON.parse_string(SAMPLE), "sample", _resolver)


func _test_from_json() -> void:
	var story := _sample()
	_check(story.title == "After the Battle", "inits the title")
	_check(story.current_page == story.root, "current page is the root")
	_check(story.history.size() == 1, "history holds the first node")
	_check(story.year == 1648 and typeof(story.year) == TYPE_INT, "year is an int")
	_check(story.authors == "Dmytro Gladkyi, Someone else", "inits the authors")
	_check(story.history[0].image_paths == PackedStringArray(["photo:river", "sketch:sample/r/0"]), "first node resolved its image with its id")
	var empty := GsStory.from_dict({"title": "t", "root": {}}, "empty", _resolver)
	_check(empty.history.is_empty(), "empty root page logs nothing")


func _test_navigation() -> void:
	var story := _sample()
	var emitted := []
	story.history_changed.connect(func(h: Array[GsHistoryItem]) -> void: emitted.append(h.size()))
	_check(story.can_continue(), "can continue on a page with more nodes")
	story.do_continue()
	_check(story.history.size() == 2 and story.history[1].image_paths.is_empty(), "continue logs the next node without image")
	_check(not story.can_continue(), "cannot continue past the last node")
	story.go_to_next_page_by_index(1)
	_check(story.history[2].text == "Run away", "a choice is logged as text")
	_check(story.history[3].text == "inner", "the next page's first node is logged")
	_check(story.path == [1], "path records the choice")
	_check(story.is_the_end(), "ALIVE page is the end")
	_check(emitted == [2, 4], "history_changed fires for continue and for a choice (choice + node)")
	_check(story.current_node_id() == "sample/r.1/0", "node id of the current node")


func _test_reset() -> void:
	var story := _sample()
	story.do_continue()
	story.go_to_next_page_by_index(1)
	story.reset()
	_check(story.history.size() == 1 and story.current_page == story.root and story.path.is_empty(), "reset starts over")
	_check(story.root.current_index == 0, "reset rewinds the root page")


func _test_steppe() -> void:
	GsImageType.legacy_ignore_steppe = true
	_check(GsImageType.from_string("steppe") == GsImageType.Type.NONE, "legacy: steppe has no image")
	GsImageType.legacy_ignore_steppe = false
	_check(GsImageType.from_string("steppe") == GsImageType.Type.STEPPE, "steppe is parsed")
	_check(GsImageType.from_string(null) == GsImageType.Type.NONE, "null image type")


func _test_save_restore_sample() -> void:
	var story := _sample()
	story.do_continue()
	story.go_to_next_page_by_index(1)
	var state: Dictionary = JSON.parse_string(JSON.stringify(story.to_state()))
	var restored := _sample()
	_check(restored.restore_state(state), "restores a saved state")
	_check(restored.current_page == restored.root.next[1].next_page, "restored page is linked into the root tree")
	_check(restored.history.size() == 4 and restored.is_the_end(), "restored history and position")
	var broken := _sample()
	_check(not broken.restore_state({"v": 1, "path": [5], "nodeIndex": 0, "history": [{"text": "x"}]}), "rejects a path that doesn't exist")
	_check(broken.history.size() == 1 and broken.current_page == broken.root, "rejected restore leaves the story at its start")


## Walks every branch of every bundled story, saving and restoring at every step,
## and compares the image nodes with the prompt files.
func _test_all_stories() -> void:
	for file in DirAccess.get_files_at(STORIES_DIR):
		if not file.ends_with(".json"):
			continue
		var path := "%s/%s" % [STORIES_DIR, file]
		var story := GsStory.load_file(path, _resolver)
		_check(story != null, "%s loads" % file)
		if story == null:
			continue
		var image_ids := {}
		var endings := [0]
		var restores := [0]
		_walk(path, [], image_ids, endings, restores)
		_check(endings[0] > 0, "%s: every branch walked, %d endings" % [file, endings[0]])
		_compare_prompts(story.id, image_ids)
		print("  %s: %d endings, %d image nodes, %d save/restore round trips" % [story.id, endings[0], image_ids.size(), restores[0]])


func _walk(path: String, choices: Array[int], image_ids: Dictionary, endings: Array, restores: Array) -> void:
	var story := GsStory.load_file(path, _resolver)
	for choice in choices:
		while story.can_continue():
			story.do_continue()
		story.go_to_next_page_by_index(choice)
	var page := story.current_page
	while true:
		var node := page.get_current_node()
		if node and node.image_type != GsImageType.Type.NONE:
			image_ids[story.current_node_id()] = true
			_check(story.history.back().image_paths.size() == 2, "%s has its image" % story.current_node_id())
		_check_round_trip(path, story)
		restores[0] += 1
		if not story.can_continue():
			break
		story.do_continue()
	if page.next.is_empty():
		endings[0] += 1
		return
	for i in page.next.size():
		var next_choices := choices.duplicate()
		next_choices.append(i)
		_walk(path, next_choices, image_ids, endings, restores)


func _check_round_trip(path: String, story: GsStory) -> void:
	var copy := GsStory.load_file(path, _resolver)
	var ok := copy.restore_state(JSON.parse_string(JSON.stringify(story.to_state())))
	_check(ok and copy.history.size() == story.history.size() and copy.current_node_id() == story.current_node_id()
			and copy.can_continue() == story.can_continue(), "round trip at %s" % story.current_node_id(), true)


func _compare_prompts(story_id: String, image_ids: Dictionary) -> void:
	var prompt_path := "%s/%s.jsonl" % [PROMPTS_DIR, story_id]
	if not FileAccess.file_exists(prompt_path):
		_check(false, "%s has prompts" % story_id)
		return
	var prompt_ids := {}
	for line in FileAccess.get_file_as_string(prompt_path).split("\n", false):
		var entry = JSON.parse_string(line)
		if entry is Dictionary and not (entry["id"].ends_with("/cover") or "/char_" in entry["id"]):
			prompt_ids[entry["id"]] = true
	var missing := image_ids.keys().filter(func(id: String) -> bool: return not prompt_ids.has(id))
	var extra := prompt_ids.keys().filter(func(id: String) -> bool: return not image_ids.has(id))
	_check(missing.is_empty() and extra.is_empty(), "%s: prompt ids match the engine's node ids (missing %s, extra %s)" % [story_id, missing, extra])


func _check(condition: bool, name: String, quiet := false) -> void:
	_checks += 1
	if not condition:
		_failures += 1
		print("FAIL: " + name)
	elif not quiet:
		print("ok   " + name)
