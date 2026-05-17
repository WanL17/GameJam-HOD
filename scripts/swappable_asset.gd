# SwappableAsset — a 3D office prop that is secretly a bug
# Attach to a MeshInstance3D node. Add an Area3D + CollisionShape3D as children.
extends MeshInstance3D

@export var normal_mesh: Mesh
@export var bug_mesh: Mesh
@export var is_bugged: bool = false

var found: bool = false
var player_nearby: bool = false

func _ready():
	mesh = bug_mesh if is_bugged else normal_mesh
	# Connect the Area3D child signals
	$Area3D.body_entered.connect(_on_body_entered)
	$Area3D.body_exited.connect(_on_body_exited)

func _unhandled_input(event):
	if event.is_action_pressed("interact") and player_nearby and is_bugged and not found:
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
