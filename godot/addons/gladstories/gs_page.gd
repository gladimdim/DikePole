class_name GsPage
extends RefCounted
## A sequence of passages followed by either choices or an ending.

enum EndType { NONE, DEAD, ALIVE }

var nodes: Array[GsPageNode] = []
var next: Array[GsPageNext] = []
var end_type := EndType.NONE
var current_index := 0


static func from_dict(map: Dictionary) -> GsPage:
	var page := GsPage.new()
	if map.is_empty():
		return page
	for node_map in map.get("nodes", []):
		page.nodes.append(GsPageNode.from_dict(node_map))
	for next_map in map.get("next", []):
		page.next.append(GsPageNext.from_dict(next_map))
	page.end_type = end_type_from_string(map.get("endType"))
	var index = map.get("currentIndex")
	page.current_index = int(index) if index != null else 0
	return page


static func end_type_from_string(value: Variant) -> EndType:
	match value:
		"DEAD":
			return EndType.DEAD
		"ALIVE":
			return EndType.ALIVE
	return EndType.NONE


func get_current_node() -> GsPageNode:
	if current_index < 0 or current_index >= nodes.size():
		return null
	return nodes[current_index]


func get_current_text() -> Variant:
	var node := get_current_node()
	return node.text if node else null


func has_next_node() -> bool:
	return current_index + 1 < nodes.size()


func has_next() -> bool:
	return not next.is_empty()


func is_the_end() -> bool:
	return end_type != EndType.NONE


func next_node() -> void:
	current_index += 1
	if current_index >= nodes.size():
		push_error("End of nodes for current page")
