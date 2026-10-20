class_name GsPageNext
extends RefCounted
## A choice shown at the end of a page: its label and the page it leads to.

var text: Variant = null
var next_page: GsPage


static func from_dict(map: Dictionary) -> GsPageNext:
	var choice := GsPageNext.new()
	choice.text = map.get("text")
	var page_map = map.get("nextPage")
	choice.next_page = GsPage.from_dict(page_map if page_map is Dictionary else {})
	return choice
