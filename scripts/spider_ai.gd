# SpiderAI — scripted event: enters room, reacts, leaves, then hunts on timeout
extends Node3D

@export var entry_position: Vector3 = Vector3(0, 0, -4)
@export var room_center: Vector3 = Vector3(0, 0, 0)
@export var exit_position: Vector3 = Vector3(0, 0, -4)
@export var move_speed: float = 4.0
@export var hunt_speed: float = 7.0
@export var time_limit: float = 300.0  # 5 minutes

@onready var label = $Label3D

var _overlay: Label = null
var _timer_label: Label = null
var _target: Vector3
var _moving: bool = false
var _done: bool = false
var _hunting: bool = false
var _player: Node3D = null
var _time_left: float = 0.0
var _timer_active: bool = false

func _ready():
	visible = false
	_overlay = _get_or_create_overlay()
	_timer_label = _get_or_create_timer_label()
	if _overlay:
		_overlay.visible = false
	_time_left = time_limit
	_timer_active = true
	_player = get_tree().root.find_child("Player", true, false) as Node3D

func _process(delta):
	if not _timer_active or _done:
		return

	# Update countdown HUD
	_time_left -= delta
	if _timer_label:
		var mins = int(_time_left) / 60
		var secs = int(_time_left) % 60
		_timer_label.text = "%02d:%02d" % [mins, secs]
		if _time_left <= 60.0:
			_timer_label.add_theme_color_override("font_color", Color(0.9, 0.1, 0.1))

	# Time ran out — start hunt
	if _time_left <= 0.0 and not _hunting:
		_timer_active = false
		if _timer_label:
			_timer_label.text = "00:00"
		_start_hunt()
		return

	# Hunt mode: chase player directly
	if _hunting and _player:
		var dir = (_player.global_position - global_position)
		dir.y = 0
		if dir.length() < 1.0:
			_on_caught_player()
			return
		global_position += dir.normalized() * hunt_speed * delta
		look_at(global_position + dir.normalized(), Vector3.UP)

func trigger():
	visible = true
	_target = room_center
	_moving = true
	await _reach_target()
	await _center_sequence()
	_target = exit_position
	_moving = true
	await _reach_target()
	visible = false


func _start_hunt():
	_hunting = true
	_moving = false
	visible = true
	_show_overlay_message("time's up.")
	await get_tree().create_timer(1.5).timeout
	_hide_overlay_message()


func _on_caught_player():
	_hunting = false
	_done = true
	_hide_overlay_message()
	if _timer_label:
		_timer_label.visible = false
	# Go back to main menu
	get_tree().change_scene_to_file("res://scenes/main_menu.tscn")


func _center_sequence():
	_moving = false
	if label:
		label.text = "!"
		label.visible = true
	await get_tree().create_timer(1.0).timeout
	if label:
		label.text = "..."
	_show_overlay_message("find every swapped object\nor i will hunt you")
	await get_tree().create_timer(4.0).timeout
	_hide_overlay_message()
	await get_tree().create_timer(1.0).timeout
	if label:
		label.visible = false


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


func _get_or_create_overlay() -> Label:
	var canvas = get_tree().root.find_child("SpiderOverlay", true, false)
	if canvas and canvas is CanvasLayer:
		return canvas.get_child(0) as Label
	var cl = CanvasLayer.new()
	cl.name = "SpiderOverlay"
	cl.layer = 10
	get_tree().root.add_child(cl)
	var lbl = Label.new()
	lbl.name = "SpiderMessage"
	lbl.text = ""
	lbl.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	lbl.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	lbl.set_anchors_preset(Control.PRESET_FULL_RECT)
	lbl.add_theme_font_size_override("font_size", 48)
	lbl.add_theme_color_override("font_color", Color(0.85, 0.1, 0.1, 1.0))
	cl.add_child(lbl)
	return lbl


func _get_or_create_timer_label() -> Label:
	var canvas = get_tree().root.find_child("SpiderTimerCanvas", true, false)
	if canvas and canvas is CanvasLayer:
		return canvas.get_child(0) as Label
	var cl = CanvasLayer.new()
	cl.name = "SpiderTimerCanvas"
	cl.layer = 9
	get_tree().root.add_child(cl)
	var lbl = Label.new()
	lbl.name = "TimerLabel"
	lbl.text = "05:00"
	# Anchor top-right
	lbl.set_anchor(SIDE_LEFT, 1.0)
	lbl.set_anchor(SIDE_TOP, 0.0)
	lbl.set_anchor(SIDE_RIGHT, 1.0)
	lbl.set_anchor(SIDE_BOTTOM, 0.0)
	lbl.set_offset(SIDE_LEFT, -140)
	lbl.set_offset(SIDE_TOP, 16)
	lbl.set_offset(SIDE_RIGHT, -16)
	lbl.set_offset(SIDE_BOTTOM, 56)
	lbl.add_theme_font_size_override("font_size", 36)
	lbl.add_theme_color_override("font_color", Color(0.9, 0.9, 0.9))
	cl.add_child(lbl)
	return lbl


func _show_overlay_message(msg: String):
	if _overlay:
		_overlay.text = msg
		_overlay.visible = true


func _hide_overlay_message():
	if _overlay:
		_overlay.visible = false
