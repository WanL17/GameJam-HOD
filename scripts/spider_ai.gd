# SpiderAI — scripted event: enters room, reacts, leaves
extends Node3D

@export var entry_position: Vector3 = Vector3(0, 0, -4)
@export var room_center: Vector3 = Vector3(0, 0, 0)
@export var exit_position: Vector3 = Vector3(0, 0, -4)
@export var move_speed: float = 4.0

@onready var label = $Label3D  # "!" speech bubble above head

var _target: Vector3
var _moving: bool = false
var _done: bool = false

func trigger():
	# Called by RoomManager when player misses a bug (optional)
	# Or just call it on a timer for atmosphere
	visible = true
	_target = room_center
	_moving = true
	await _reach_target()
	_react()
	await get_tree().create_timer(2.0).timeout
	_target = exit_position
	_moving = true
	await _reach_target()
	visible = false
	_done = true

func _physics_process(delta):
	if not _moving:
		return
	var dir = (_target - global_position)
	dir.y = 0
	if dir.length() < 0.2:
		_moving = false
		return
	global_position += dir.normalized() * move_speed * delta
	look_at(global_position + dir.normalized(), Vector3.UP)

func _reach_target() -> void:
	_moving = true
	while _moving:
		await get_tree().process_frame

func _react():
	_moving = false
	if label:
		label.text = "!"
		label.visible = true
	await get_tree().create_timer(0.5).timeout
	if label:
		label.text = "..."
	await get_tree().create_timer(1.5).timeout
	if label:
		label.visible = false
