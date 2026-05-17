extends Node3D

@onready var spider = $SpiderAI
@onready var exit_door = $ExitDoor  # Must be the door Node3D with inverted_door.gd

var _swappables: Array = []

func _ready():
	RoomManager.init_room(3)
	RoomManager.exit_door = exit_door
	RoomManager.spider = spider
	_swappables = _find_swappables(get_tree().root)
	get_tree().create_timer(30.0).timeout.connect(_activate_swaps)

func _activate_swaps():
	for s in _swappables:
		s.activate_bug()
	spider.start_timer()
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
