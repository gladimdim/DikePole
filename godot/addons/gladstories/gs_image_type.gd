class_name GsImageType
extends RefCounted
## Image themes a story node can ask for. Mirrors `ImageType` in gladstoriesengine.

enum Type { NONE = -1, BOAT, STEPPE, FOREST, BULRUSH, RIVER, LANDING, CAMP, COSSACKS }

## The Dart engine never parsed "steppe" (no case in imageTypeFromString), so those
## nodes showed no picture. Kept switchable so tests can reproduce the original.
static var legacy_ignore_steppe := false

const _BY_NAME := {
	"boat": Type.BOAT,
	"steppe": Type.STEPPE,
	"forest": Type.FOREST,
	"bulrush": Type.BULRUSH,
	"river": Type.RIVER,
	"landing": Type.LANDING,
	"camp": Type.CAMP,
	"cossacks": Type.COSSACKS,
}


static func from_string(value: Variant) -> Type:
	if typeof(value) != TYPE_STRING:
		return Type.NONE
	if value == "steppe" and legacy_ignore_steppe:
		return Type.NONE
	return _BY_NAME.get(value, Type.NONE)


static func to_name(type: Type) -> String:
	for key in _BY_NAME:
		if _BY_NAME[key] == type:
			return key
	return ""
