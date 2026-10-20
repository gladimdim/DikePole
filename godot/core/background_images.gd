extends Node
## Picks the picture for a story node and describes how it animates.
##
## A generated per-node picture is used when it exists (images/manifest.json "nodes").
## Otherwise a random photo/sketch pair comes from the theme pool, without repeats
## until the pool is used up, like Flutter's BackgroundImage/RandomImage.

const MANIFEST_PATH := "res://images/manifest.json"
const T := GsImageType.Type
## Themes without their own pictures borrow a pool, as in the Flutter app.
const POOL_OF := {
	T.BOAT: "boat",
	T.STEPPE: "river",
	T.FOREST: "forest",
	T.BULRUSH: "bulrush",
	T.RIVER: "river",
	T.LANDING: "landing",
	T.CAMP: "camp",
	T.COSSACKS: "camp",
}
const PASSAGE_DURATION_CLASSIC := 6.0
const CARD_DURATION_CLASSIC := 4.0
const REVEAL_DURATION := 3.2

const _REVEALS := {"fade": StoryImage.Reveal.FADE, "sketch": StoryImage.Reveal.SKETCH,
		"develop": StoryImage.Reveal.DEVELOP, "ink": StoryImage.Reveal.INK}
const _MOTIONS := {"static": StoryImage.Motion.STATIC, "push_in": StoryImage.Motion.PUSH_IN,
		"pull_out": StoryImage.Motion.PULL_OUT, "pan_left": StoryImage.Motion.PAN_LEFT,
		"pan_right": StoryImage.Motion.PAN_RIGHT, "tilt_up": StoryImage.Motion.TILT_UP,
		"tilt_down": StoryImage.Motion.TILT_DOWN}
const _AMBIENTS := {"none": StoryImage.Ambient.NONE, "fire": StoryImage.Ambient.FIRE,
		"mist": StoryImage.Ambient.MIST, "water": StoryImage.Ambient.WATER,
		"wind": StoryImage.Ambient.WIND, "rain": StoryImage.Ambient.RAIN,
		"snow": StoryImage.Ambient.SNOW, "smoke": StoryImage.Ambient.SMOKE,
		"dust": StoryImage.Ambient.DUST, "night": StoryImage.Ambient.NIGHT}

## Flutter advanced a pool only when the reader pressed Next, so a picture could
## repeat right after a choice. False advances after every pick.
var legacy_random := false

var _pools := {}
var _nodes := {}
var _covers := {}
var _random := {}
var _meta_by_image := {}


func _ready() -> void:
	var manifest = JSON.parse_string(FileAccess.get_file_as_string(MANIFEST_PATH))
	if not manifest is Dictionary:
		push_error("Cannot read %s" % MANIFEST_PATH)
		return
	_pools = manifest.get("pools", {})
	_nodes = manifest.get("nodes", {})
	_covers = manifest.get("covers", {})
	for spec in _nodes.values() + _covers.values():
		_meta_by_image[spec["image"]] = spec
	AppPrefs.changed.connect(func(key: String) -> void:
		if key == "classicLook":
			_random.clear())


## Image resolver for GsStory: [photo, sketch] of a pool pair or [generated].
func resolve(type: GsImageType.Type, node_id: String) -> PackedStringArray:
	if not AppPrefs.classic_look and _nodes.has(node_id):
		return PackedStringArray([_nodes[node_id]["image"]])
	var pool := _pool_for(type)
	if pool == null:
		return PackedStringArray()
	var pair: Dictionary = pool.current()
	if not legacy_random:
		pool.next_random()
	return PackedStringArray([pair["photo"], pair["sketch"]])


## Flutter called BackgroundImage.nextRandomForType on Next (see legacy_random).
func next_random_for_type(type: GsImageType.Type) -> void:
	var pool := _pool_for(type)
	if pool:
		pool.next_random()


## Picture spec for a passage of the story view.
func passage_spec(paths: PackedStringArray) -> Dictionary:
	if paths.size() == 2:
		if AppPrefs.classic_look:
			# Flutter TweenImage(first: photo, last: sketch, duration: 6).
			return {"from": paths[0], "to": paths[1], "classic": true, "duration": PASSAGE_DURATION_CLASSIC}
		return {"from": paths[1], "to": paths[0], "reveal": StoryImage.Reveal.SKETCH,
				"duration": REVEAL_DURATION, "motion": StoryImage.Motion.PUSH_IN}
	if paths.size() == 1:
		return _generated_spec(_meta_by_image.get(paths[0], {"image": paths[0]}))
	return {}


## Picture spec for a catalog card: a new random landing picture each time, sketch to
## photo (Flutter TweenImage(first: sketch, last: photo, duration: 4)), or the
## generated cover of the story.
func card_spec(story_id: String) -> Dictionary:
	if not AppPrefs.classic_look and _covers.has(story_id):
		return _generated_spec(_covers[story_id])
	var pool := _pool_for(T.LANDING)
	pool.next_random()
	var pair: Dictionary = pool.current()
	if AppPrefs.classic_look:
		return {"from": pair["sketch"], "to": pair["photo"], "classic": true, "duration": CARD_DURATION_CLASSIC}
	return {"from": pair["sketch"], "to": pair["photo"], "reveal": StoryImage.Reveal.SKETCH,
			"duration": CARD_DURATION_CLASSIC, "motion": StoryImage.Motion.PUSH_IN}


## The picture that represents a story on the home and story screens: its
## generated cover, or a photo from the pool of the story's first image theme,
## always the same one for the same story. Animated = a slow push-in (story screen,
## where the list thumbnail flies in as a photo); otherwise a short fade (lists).
func cover_spec(entry: Dictionary, animated := false) -> Dictionary:
	var id := StoryLibrary.story_id(entry)
	if _covers.has(id):
		var spec := _generated_spec(_covers[id])
		spec.merge({"reveal": StoryImage.Reveal.FADE, "duration": 0.0 if animated else 0.35}, true)
		if not animated:
			spec["motion"] = StoryImage.Motion.STATIC
		return spec
	var theme := GsImageType.from_string(StoryLibrary.stats(entry).get("theme", "landing"))
	var images: Array = _pools.get(POOL_OF.get(theme, "landing"), {}).get("images", [])
	if images.is_empty():
		images = _pools.get("landing", {}).get("images", [])
	var pair: Dictionary = images[absi(hash(id)) % images.size()]
	if animated:
		return {"to": pair["photo"], "reveal": StoryImage.Reveal.FADE, "duration": 0.0,
				"motion": StoryImage.Motion.PUSH_IN}
	return {"to": pair["photo"], "reveal": StoryImage.Reveal.FADE, "duration": 0.35}


## Every landing picture, for preloading when the catalog opens.
func landing_paths() -> PackedStringArray:
	var paths := PackedStringArray()
	for pair in _pools.get("landing", {}).get("images", []):
		paths.append(pair["photo"])
		paths.append(pair["sketch"])
	for spec in _covers.values():
		paths.append(spec["image"])
	return paths


func _generated_spec(meta: Dictionary) -> Dictionary:
	var motion: Dictionary = meta.get("motion", {})
	var focus: Array = motion.get("focus", [0.5, 0.5])
	var region: Array = meta.get("ambient_region", [0, 0, 1, 1])
	return {
		"to": meta["image"],
		"reveal": _REVEALS.get(meta.get("reveal", "sketch"), StoryImage.Reveal.SKETCH),
		"duration": REVEAL_DURATION,
		"motion": _MOTIONS.get(motion.get("type", "push_in"), StoryImage.Motion.PUSH_IN),
		"focus": Vector2(focus[0], focus[1]),
		"ambient": _AMBIENTS.get(meta.get("ambient", "none"), StoryImage.Ambient.NONE),
		"ambient_region": Rect2(region[0], region[1], region[2], region[3]),
	}


func _pool_for(type: GsImageType.Type) -> RandomPool:
	if not POOL_OF.has(type):
		return null
	if not _random.has(type):
		var pool: Dictionary = _pools.get(POOL_OF[type], {})
		var images: Array = pool.get("images", [])
		if AppPrefs.classic_look:
			images = images.slice(0, pool.get("legacy_size", images.size()))
		if images.is_empty():
			return null
		_random[type] = RandomPool.new(images)
	return _random[type]


## Random pick without repeats until every item was used (Flutter RandomImage).
class RandomPool:
	var _items: Array
	var _current: int
	var _used: Array[int] = []

	func _init(items: Array) -> void:
		_items = items
		_current = randi_range(0, _items.size() - 1)
		_used = [_current]

	func current() -> Dictionary:
		return _items[_current]

	func next_random() -> void:
		if _used.size() >= _items.size():
			_used = []
		var candidate := randi_range(0, _items.size() - 1)
		while candidate in _used:
			candidate = randi_range(0, _items.size() - 1)
		_current = candidate
		_used.append(candidate)
