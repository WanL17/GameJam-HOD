# SwappableAsset — a 3D office prop that is secretly a bug
# Attach to a MeshInstance3D node. Add an Area3D + CollisionShape3D as children.
extends MeshInstance3D

@export var normal_mesh: Mesh
@export var bug_mesh: Mesh
@export var is_bugged: bool = false

var found: bool = false
var player_nearby: bool = false
var _activated: bool = false

func _ready():
	# Always start with normal mesh so player can memorise the room
	mesh = normal_mesh
	$Area3D.body_entered.connect(_on_body_entered)
	$Area3D.body_exited.connect(_on_body_exited)

func activate_bug():
	# Called by room after 30s — only actually swaps if this object is flagged
	if not is_bugged:
		return
	_activated = true
	# Small tween flash so the player notices something changed
	mesh = bug_mesh

func _unhandled_input(event):
	if event.is_action_pressed("interact") and player_nearby and _activated and not found:
		_on_found()

func _on_found():
	found = true
	var tween = create_tween()
	tween.tween_property(self, "material_override:albedo_color", Color(1, 0.2, 0.2), 0.1)
	tween.tween_property(self, "material_override:albedo_color", Color(1, 1, 1), 0.1)
	tween.tween_property(self, "material_override:albedo_color", Color(1, 0.2, 0.2), 0.1)
	tween.tween_property(self, "material_override:albedo_color", Color(1, 1, 1), 0.15)
	RoomManager.register_found()

func _on_body_entered(body):
	if body is CharacterBody3D:
		player_nearby = true

func _on_body_exited(body):
	if body is CharacterBody3D:
		player_nearby = false
