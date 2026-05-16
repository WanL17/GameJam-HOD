# HidingSpot — an Area2D the player can duck into to avoid the spider
extends Area2D

func _ready():
	body_entered.connect(_on_body_entered)
	body_exited.connect(_on_body_exited)

func _on_body_entered(body):
	if body.is_in_group("player"):
		body.can_hide = true

func _on_body_exited(body):
	if body.is_in_group("player"):
		body.can_hide = false
		if body.is_hidden:
			body._exit_hide()
