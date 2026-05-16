# CoffeeMachine — the final interactable in room_coffee
# Triggers the win sequence when the player uses it.
extends Sprite2D

var player_nearby: bool = false

func _unhandled_input(event):
	if event.is_action_pressed("interact") and player_nearby:
		_brew()

func _brew():
	# Show a brief "you wake up" overlay then go to main menu with coffee
	var overlay = CanvasLayer.new()
	var label = Label.new()
	label.text = "You reach out... take a sip...

*You wake up at your desk.*"
	label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	label.set_anchors_preset(Control.PRESET_FULL_RECT)
	overlay.add_child(label)
	add_child(overlay)
	await get_tree().create_timer(3.0).timeout
	GameManager.win()

func on_player_entered():
	player_nearby = true

func on_player_exited():
	player_nearby = false
