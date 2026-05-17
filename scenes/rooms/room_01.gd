extends Node3D

@onready var spider = $SpiderAI

func _ready():
	RoomManager.init_room(3)
	# Spider does the intro visit after 30s
	get_tree().create_timer(30.0).timeout.connect(_spider_visit)

func _spider_visit():
	if RoomManager.found_bugs < RoomManager.total_bugs:
		spider.trigger()
