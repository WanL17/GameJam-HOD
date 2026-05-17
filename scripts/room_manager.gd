# RoomManager — Autoload singleton
extends Node

var total_bugs: int = 0
var found_bugs: int = 0
var exit_door = null   # Set by room script, ref to inverted_door node
var spider = null      # Set by room script, ref to SpiderAI node

func init_room(bug_count: int):
	total_bugs = bug_count
	found_bugs = 0
	exit_door = null
	spider = null

func register_found():
	found_bugs += 1
	print("Bugs found: %d / %d" % [found_bugs, total_bugs])
	if found_bugs >= total_bugs:
		_on_room_cleared()

func _on_room_cleared():
	# Stop the spider/timer immediately
	if spider and is_instance_valid(spider):
		spider.stop_timer()
	# Unlock the exit door
	if exit_door and is_instance_valid(exit_door):
		exit_door.unlock()
	await get_tree().create_timer(1.0).timeout
	GameManager.advance_room()
