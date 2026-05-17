extends Node3D

@onready var spider = $SpiderAI

func _ready():
	RoomManager.init_room(3)
	get_tree().create_timer(10.0).timeout.connect(_spider_visit)

func _spider_visit():
	if not RoomManager.found_bugs >= RoomManager.total_bugs:
		spider.trigger()
