# MainMenu — shows different states based on win/lose
extends Node

@onready var coffee_sprite = $CoffeeSprite       # Visible only on win
@onready var no_coffee_label = $NoCoffeeLabel    # Visible only on lose
@onready var start_button = $StartButton
@onready var quit_button = $QuitButton

func _ready():
	_update_ui()
	start_button.pressed.connect(_on_start)
	quit_button.pressed.connect(_on_quit)

func _update_ui():
	if GameManager.has_coffee:
		coffee_sprite.visible = true
		no_coffee_label.visible = false
	else:
		coffee_sprite.visible = false
		no_coffee_label.visible = GameManager.current_room > 0  # Only show on retry

func _on_start():
	GameManager.reset()
	get_tree().change_scene_to_file("res://scenes/rooms/room_00.tscn")

func _on_quit():
	get_tree().quit()
