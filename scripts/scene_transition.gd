extends Area3D

@export var next_scene: String = "res://scenes/rooms/room_01.tscn"
@export var spawn_position: Vector3 = Vector3(0, 1, -4)
# spawn_position = where player appears in the next scene
# set it to halfway through room_01's corridor

var triggered = false

func _ready():
	body_entered.connect(_on_body_entered)

func _on_body_entered(body):
	if triggered:
		return
	if body is CharacterBody3D:
		triggered = true
		GameManager.next_spawn = spawn_position
		get_tree().change_scene_to_file(next_scene)
