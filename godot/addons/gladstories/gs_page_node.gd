class_name GsPageNode
extends RefCounted
## One passage of a page. The player presses "Next" to move between nodes.

var text: Variant = null
var image_type := GsImageType.Type.NONE


static func from_dict(map: Dictionary) -> GsPageNode:
	var node := GsPageNode.new()
	node.text = map.get("text")
	node.image_type = GsImageType.from_string(map.get("imageType"))
	return node
