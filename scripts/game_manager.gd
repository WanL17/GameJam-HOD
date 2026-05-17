# GameManager — Autoload singleton
# Tracks global game state across scenes.
extends Node

var has_coffee: bool = false
var current_room: int = 0
var total_rooms: int = 3  # Adjust to match how many rooms you build
var next_spawn: Vector3 = Vector3(0, 0.2, -15)


func reset():
	has_coffee = false
	current_room = 0

func advance_room():
	current_room += 1
	if current_room >= total_rooms:
		# All rooms cleared — go to the coffee machine room
		get_tree().change_scene_to_file("res://scenes/rooms/room_coffee.tscn")
	else:
		get_tree().change_scene_to_file("res://scenes/rooms/room_%02d.tscn" % current_room)

func win():
	has_coffee = true
	get_tree().change_scene_to_file("res://scenes/main_menu.tscn")

func lose():
	has_coffee = false
	get_tree().change_scene_to_file("res://scenes/main_menu.tscn")
