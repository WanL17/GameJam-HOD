# Player controller — top-down 3D movement + interaction + hiding
extends CharacterBody3D

@export var speed: float = 5.0

var can_hide: bool = false
var is_hidden: bool = false

func _ready():
	print("Player spawned at: ", global_position)
	if GameManager.next_spawn != Vector3.ZERO:
		global_position = GameManager.next_spawn
		GameManager.next_spawn = Vector3.ZERO

func _physics_process(_delta):
	if is_hidden:
		return

	var dir = Vector3(
		Input.get_axis("ui_left", "ui_right"),
		0,
		Input.get_axis("ui_up", "ui_down")
	).normalized()

	velocity = dir * speed
	if not is_on_floor():
		velocity.y -= 9.8 * _delta
	move_and_slide()

func _unhandled_input(event):
	if event.is_action_pressed("hide"):
		if can_hide and not is_hidden:
			_enter_hide()
		elif is_hidden:
			_exit_hide()

func _enter_hide():
	is_hidden = true
	$PlayerMesh.transparency = 0.7

func _exit_hide():
	is_hidden = false
	$PlayerMesh.transparency = 0.0

func die():
	GameManager.lose()
