extends Node3D

@onready var spider = $SpiderAI

# Collect all swappable objects in the room
var _swappables: Array = []

func _ready():
	RoomManager.init_room(3)
	# Disable hunt timer until swap happens
	spider._timer_active = false

	# Find every SwappableAsset in the room
	_swappables = _find_swappables(get_tree().root)

	# After 30s: swap objects so player has seen the normal state
	get_tree().create_timer(30.0).timeout.connect(_activate_swaps)

func _activate_swaps():
	for s in _swappables:
		s.activate_bug()
	# Now start the 5-minute hunt countdown
	spider._time_left = spider.time_limit
	spider._timer_active = true
	# Spider visits 30s after swaps appear
	get_tree().create_timer(30.0).timeout.connect(_spider_visit)

func _spider_visit():
	if RoomManager.found_bugs < RoomManager.total_bugs:
		spider.trigger()

func _find_swappables(node: Node) -> Array:
	var result = []
	for child in node.get_children():
		if child.get_script() != null:
			var path = child.get_script().resource_path
			if path.ends_with("swappable_asset.gd"):
				result.append(child)
		result.append_array(_find_swappables(child))
	return result
