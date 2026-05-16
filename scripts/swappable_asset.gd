# SwappableAsset — an office prop that may secretly be a bug
# Set is_bugged = true in the editor for the ones the player must find.
extends Sprite2D

@export var normal_texture: Texture2D
@export var bug_texture: Texture2D
@export var is_bugged: bool = false
@export var interact_radius: float = 40.0

var found: bool = false
var player_nearby: bool = false

func _ready():
	if is_bugged:
		texture = bug_texture
	else:
		texture = normal_texture

func _unhandled_input(event):
	if event.is_action_pressed("interact") and player_nearby and is_bugged and not found:
		_on_found()

func _on_found():
	found = true
	# Glitch flash effect
	var tween = create_tween()
	tween.tween_property(self, "modulate", Color(1, 0.2, 0.2), 0.1)
	tween.tween_property(self, "modulate", Color(1, 1, 1), 0.1)
	tween.tween_property(self, "modulate", Color(1, 0.2, 0.2), 0.1)
	tween.tween_property(self, "modulate", Color(1, 1, 1), 0.15)
	RoomManager.register_found()

# Call these from an Area2D overlap signal on the asset node
func on_player_entered():
	player_nearby = true

func on_player_exited():
	player_nearby = false
