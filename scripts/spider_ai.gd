# SpiderAI — scripted event: enters room, reacts, leaves
extends Node3D

@export var entry_position: Vector3 = Vector3(0, 0, -4)
@export var room_center: Vector3 = Vector3(0, 0, 0)
@export var exit_position: Vector3 = Vector3(0, 0, -4)
@export var move_speed: float = 4.0

@onready var label = $Label3D  # "!" speech bubble above head

# Overlay label — assign in Inspector or we create it at runtime
var _overlay: Label = null

var _target: Vector3
var _moving: bool = false
var _done: bool = false

func _ready():
	visible = false
	_overlay = _get_or_create_overlay()
	if _overlay:
		_overlay.visible = false

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
	_done = true

func _center_sequence():
	_moving = false

	# Phase 1 — spider reacts
	if label:
		label.text = "!"
		label.visible = true
	await get_tree().create_timer(1.0).timeout

	# Phase 2 — scary message appears on screen
	if label:
		label.text = "..."
	_show_overlay_message("find every swapped object\nor i will hunt you")
	await get_tree().create_timer(4.0).timeout

	# Phase 3 — message fades out
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
	# Try to find an existing CanvasLayer > Label in the tree
	var canvas = get_tree().root.find_child("SpiderOverlay", true, false)
	if canvas and canvas is CanvasLayer:
		return canvas.get_child(0) as Label

	# Create one at runtime
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

func _show_overlay_message(msg: String):
	if _overlay:
		_overlay.text = msg
		_overlay.visible = true

func _hide_overlay_message():
	if _overlay:
		_overlay.visible = false
