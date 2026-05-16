extends Node3D

@export var is_locked: bool = true  # Starts "open looking" but blocked
@onready var collision = $CollisionShape3D
@onready var open_mesh = $OpenMesh    # Mesh that shows when locked
@onready var closed_mesh = $ClosedMesh  # Mesh that shows when unlocked

func _ready():
	_update_visuals()

func unlock():
	is_locked = false
	_update_visuals()

func _update_visuals():
	collision.disabled = !is_locked  # Blocked when locked
	open_mesh.visible = is_locked    # Open texture shown when blocked
	closed_mesh.visible = !is_locked # Closed texture shown when passable
