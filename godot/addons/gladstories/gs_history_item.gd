class_name GsHistoryItem
extends RefCounted
## A line the player has already seen: a passage, or the text of a choice they made.

var text: Variant = null
## Image paths shown above the text. Two entries for the original photo/sketch pairs
## (photo first, as in the Dart engine), one for single generated images, or none.
var image_paths := PackedStringArray()
## Stable id of the node that produced this item ("" for choices), used to look up
## per-node image metadata.
var node_id := ""


static func create(item_text: Variant, paths := PackedStringArray(), id := "") -> GsHistoryItem:
	var item := GsHistoryItem.new()
	item.text = item_text
	item.image_paths = paths
	item.node_id = id
	return item


func to_dict() -> Dictionary:
	return {"text": text, "imagePath": Array(image_paths), "node": node_id}


static func from_dict(map: Dictionary) -> GsHistoryItem:
	var paths := PackedStringArray()
	for path in map.get("imagePath", []):
		paths.append(str(path))
	return create(map.get("text"), paths, str(map.get("node", "")))
