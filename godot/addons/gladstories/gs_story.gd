class_name GsStory
extends RefCounted
## Runtime of the Glad Stories interactive fiction engine (port of gladstoriesengine 0.3.2).
##
## Loads a story from its JSON, walks it as the player presses Next or picks choices,
## records what was shown in [member history] and saves/restores progress.

## Emitted after every change of [member history] (Next, a choice, reset). Replaces
## the Dart `historyChanges` stream.
signal history_changed(history: Array[GsHistoryItem])

const SAVE_VERSION := 1

var id := ""
var title := ""
var description := ""
var authors := ""
var year := 0
var root: GsPage
var current_page: GsPage
var history: Array[GsHistoryItem] = []
## Choice indices taken from [member root] to [member current_page].
var path: Array[int] = []
## Callable(type: GsImageType.Type, node_id: String) -> PackedStringArray.
var image_resolver := Callable()


static func from_dict(map: Dictionary, story_id := "", resolver := Callable()) -> GsStory:
	var story := GsStory.new()
	story.id = story_id
	story.title = str(map.get("title", ""))
	story.description = str(map.get("description", ""))
	story.authors = str(map.get("authors", ""))
	# Godot parses every JSON number as float.
	story.year = int(map.get("year", 0))
	story.root = GsPage.from_dict(map.get("root", {}))
	story.current_page = story.root
	story.image_resolver = resolver
	story._log_current_passage()
	return story


static func load_file(res_path: String, resolver := Callable()) -> GsStory:
	var text := FileAccess.get_file_as_string(res_path)
	var map = JSON.parse_string(text)
	if not map is Dictionary:
		push_error("Cannot parse story %s" % res_path)
		return null
	return from_dict(map, res_path.get_file().get_basename(), resolver)


## Starts reading from the beginning.
func reset() -> void:
	history = []
	path = []
	current_page = root
	current_page.current_index = 0
	_log_current_passage()


func can_continue() -> bool:
	return current_page.has_next_node()


func is_the_end() -> bool:
	return not can_continue() and current_page.is_the_end()


## Moves to the next passage on the current page.
func do_continue() -> void:
	if not can_continue():
		push_error("CannotContinue: the page has no more nodes")
		return
	current_page.next_node()
	_log_current_passage()


## Follows a choice of the current page.
func go_to_next_page(choice: GsPageNext) -> void:
	var index := current_page.next.find(choice)
	if index < 0:
		push_error("The choice does not belong to the current page")
		return
	go_to_next_page_by_index(index)


func go_to_next_page_by_index(index: int) -> void:
	var choice := current_page.next[index]
	history.append(GsHistoryItem.create(choice.text))
	path.append(index)
	current_page = choice.next_page
	current_page.current_index = 0
	_log_current_passage()


## Stable id of a node, also used to find its generated image:
## "<story id>/r.<choice>.<choice>/<node index>".
func node_id(page_path: Array[int], node_index: int) -> String:
	var parts := PackedStringArray(["r"])
	for choice in page_path:
		parts.append(str(choice))
	return "%s/%s/%d" % [id, ".".join(parts), node_index]


func current_node_id() -> String:
	return node_id(path, current_page.current_index)


func to_state() -> Dictionary:
	var items := []
	for item in history:
		items.append(item.to_dict())
	return {"v": SAVE_VERSION, "path": path.duplicate(), "nodeIndex": current_page.current_index, "history": items}


## Restores progress saved by [method to_state]. Returns false (and leaves the story
## at its beginning) when the save doesn't fit this story any more.
func restore_state(state: Dictionary) -> bool:
	if int(state.get("v", 0)) != SAVE_VERSION:
		return false
	var page := root
	var restored_path: Array[int] = []
	for raw in state.get("path", []):
		var index := int(raw)
		if index < 0 or index >= page.next.size():
			return false
		restored_path.append(index)
		page = page.next[index].next_page
	var node_index := int(state.get("nodeIndex", 0))
	if node_index < 0 or node_index >= page.nodes.size():
		return false
	var restored_history: Array[GsHistoryItem] = []
	for item in state.get("history", []):
		if item is Dictionary:
			restored_history.append(GsHistoryItem.from_dict(item))
	if restored_history.is_empty():
		return false
	path = restored_path
	current_page = page
	current_page.current_index = node_index
	history = restored_history
	history_changed.emit(history)
	return true


func _log_current_passage() -> void:
	var node := current_page.get_current_node()
	if node == null:
		return
	var paths := PackedStringArray()
	var id_of_node := current_node_id()
	if node.image_type != GsImageType.Type.NONE and image_resolver.is_valid():
		paths = image_resolver.call(node.image_type, id_of_node)
	history.append(GsHistoryItem.create(node.text, paths, id_of_node))
	history_changed.emit(history)
