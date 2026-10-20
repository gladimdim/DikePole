extends Node
## The bundled story catalog: opening/saving stories, and what the home screen shows
## about each one (length, endings, the reader's progress).

const CATALOG_PATH := "res://assets/story_catalog.json"
## The Flutter catalog hid this title (it no longer matches any story).
const HIDDEN_TITLES := ["Після Битви"]
## Reading speed for the time estimate, characters per minute.
const CHARS_PER_MINUTE := 1100.0

enum Status { NEW, READING, FINISHED }

## Entries of story_catalog.json: title, description, author, storyPath, year.
var catalog: Array[Dictionary] = []

var _stats := {}
var _trees := {}


func _ready() -> void:
	var parsed = JSON.parse_string(FileAccess.get_file_as_string(CATALOG_PATH))
	if not parsed is Dictionary:
		push_error("Cannot read %s" % CATALOG_PATH)
		return
	for entry in parsed.get("stories", []):
		if not entry.get("title") in HIDDEN_TITLES:
			catalog.append(entry)
	# Flutter sorted by the year string.
	catalog.sort_custom(func(a: Dictionary, b: Dictionary) -> bool: return str(a["year"]) < str(b["year"]))


static func story_id(entry: Dictionary) -> String:
	return str(entry["storyPath"]).get_file().get_basename()


## Opens a story where the player left off, or from the beginning.
func open(entry: Dictionary) -> GsStory:
	var story := GsStory.load_file("res://" + entry["storyPath"], BackgroundImages.resolve)
	if story == null:
		return null
	var state := AppPrefs.load_story_state(story.id)
	if not state.is_empty() and not story.restore_state(state):
		push_warning("Saved progress of %s doesn't fit the story any more, starting over" % story.id)
	return story


## Fresh copy of the story at its beginning (Reset / Start over).
func reopen_from_start(entry: Dictionary) -> GsStory:
	var story := GsStory.load_file("res://" + entry["storyPath"], BackgroundImages.resolve)
	save(story)
	return story


func save(story: GsStory) -> void:
	var state := story.to_state()
	state["savedAt"] = Time.get_unix_time_from_system()
	AppPrefs.save_story_state(story.id, state)
	if story.is_the_end() or (not story.can_continue() and not story.current_page.has_next()):
		var kind := "OPEN"
		match story.current_page.end_type:
			GsPage.EndType.ALIVE:
				kind = "ALIVE"
			GsPage.EndType.DEAD:
				kind = "DEAD"
		AppPrefs.record_ending(story.id, _path_key(story.path), kind)


## Static facts of a story: minutes (one average playthrough), endings
## (page path -> kind), choices, passages, language ("uk"/"en"), first image theme.
func stats(entry: Dictionary) -> Dictionary:
	var id := story_id(entry)
	if _stats.has(id):
		return _stats[id]
	var map = _tree(entry)
	var result := {"endings": {}, "choices": 0, "passages": 0, "theme": "", "minutes": 1, "language": "uk"}
	if map is Dictionary:
		var root: Dictionary = map.get("root", {})
		var path_chars := []
		_walk(root, "r", 0, result, path_chars)
		var average := 0.0
		for chars in path_chars:
			average += chars
		average /= maxf(1.0, path_chars.size())
		result["minutes"] = maxi(1, ceili(average / CHARS_PER_MINUTE))
		result["language"] = "uk" if _has_cyrillic(str(map.get("title", ""))) else "en"
	_stats[id] = result
	return result


## The reader's progress: status, percent (0..100) of an average playthrough,
## endings found and when the story was last read (unix time, 0 = never).
func progress(entry: Dictionary) -> Dictionary:
	var id := story_id(entry)
	var found := AppPrefs.endings_found(id)
	var state := AppPrefs.load_story_state(id)
	var result := {"status": Status.FINISHED if not found.is_empty() else Status.NEW, "percent": 0,
			"found": found, "saved_at": float(state.get("savedAt", 0.0))}
	if state.is_empty():
		return result
	var map = _tree(entry)
	if not map is Dictionary:
		return result
	var read := 0
	for item in state.get("history", []):
		read += str(item.get("text", "")).length()
	var page: Dictionary = map.get("root", {})
	for raw in state.get("path", []):
		var next: Array = page.get("next", [])
		var index := int(raw)
		if index < 0 or index >= next.size():
			return result
		page = next[index].get("nextPage", {})
	var remaining := 0
	var nodes: Array = page.get("nodes", [])
	for i in range(int(state.get("nodeIndex", 0)) + 1, nodes.size()):
		remaining += str(nodes[i].get("text", "")).length()
	remaining += _average_below(page)
	if remaining == 0:
		result["status"] = Status.FINISHED
		result["percent"] = 100
		return result
	# A story that was only opened (first passage) still counts as started.
	result["status"] = Status.READING
	result["percent"] = clampi(roundi(100.0 * read / (read + remaining)), 1, 99)
	return result


## The story read most recently that isn't finished, or {}.
func last_unfinished() -> Dictionary:
	var best := {}
	var best_time := 0.0
	for entry in catalog:
		var p := progress(entry)
		if p["status"] == Status.READING and p["saved_at"] > best_time:
			best = entry
			best_time = p["saved_at"]
	return best


func _walk(page: Dictionary, path: String, chars: int, result: Dictionary, path_chars: Array) -> void:
	for node in page.get("nodes", []):
		chars += str(node.get("text", "")).length()
		result["passages"] += 1
		if result["theme"] == "" and node.get("imageType") is String:
			result["theme"] = node["imageType"]
	var next: Array = page.get("next", [])
	if next.is_empty():
		var kind = page.get("endType")
		result["endings"][path] = kind if kind is String else "OPEN"
		path_chars.append(chars)
		return
	result["choices"] += next.size()
	for i in next.size():
		_walk(next[i].get("nextPage", {}), "%s.%d" % [path, i], chars + str(next[i].get("text", "")).length(), result, path_chars)


## Average characters still to read after this page's nodes, over its choices.
func _average_below(page: Dictionary) -> int:
	var next: Array = page.get("next", [])
	if next.is_empty():
		return 0
	var total := 0
	for choice in next:
		var child: Dictionary = choice.get("nextPage", {})
		var own := 0
		for node in child.get("nodes", []):
			own += str(node.get("text", "")).length()
		total += own + _average_below(child)
	return total / next.size()


## Parsed story JSON, cached (the home screen asks for every story).
func _tree(entry: Dictionary) -> Variant:
	var id := story_id(entry)
	if not _trees.has(id):
		_trees[id] = JSON.parse_string(FileAccess.get_file_as_string("res://" + entry["storyPath"]))
	return _trees[id]


static func _path_key(path: Array[int]) -> String:
	var parts := PackedStringArray(["r"])
	for choice in path:
		parts.append(str(choice))
	return ".".join(parts)


static func _has_cyrillic(text: String) -> bool:
	for i in text.length():
		var code := text.unicode_at(i)
		if code >= 0x400 and code <= 0x4FF:
			return true
	return false
