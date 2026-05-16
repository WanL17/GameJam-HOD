# RoomManager — Autoload singleton
# Tracks bug asset discovery progress for the current room.
extends Node

var total_bugs: int = 0
var found_bugs: int = 0

func init_room(bug_count: int):
	total_bugs = bug_count
	found_bugs = 0

func register_found():
	found_bugs += 1
	print("Bugs found: %d / %d" % [found_bugs, total_bugs])
	if found_bugs >= total_bugs:
		_on_room_cleared()

func _on_room_cleared():
	# Brief delay before advancing so the player can feel the moment
	await get_tree().create_timer(1.0).timeout
	GameManager.advance_room()
