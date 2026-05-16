# SpiderAI — state machine: WANDER > CHASE > SEARCH
extends CharacterBody3D

enum State { WANDER, CHASE, SEARCH }

@export var wander_speed: float = 3.0
@export var chase_speed: float = 7.0
@export var search_duration: float = 3.0
@export var detection_radius: float = 8.0
@export var catch_radius: float = 1.0

var state: State = State.WANDER
var player: Node3D = null
var nav: NavigationAgent3D
var wander_target: Vector3
var search_timer: float = 0.0

func _ready():
	nav = $NavigationAgent3D
	player = get_tree().get_first_node_in_group("player")
	_pick_wander_target()

func _physics_process(delta):
	match state:
		State.WANDER: _do_wander(delta)
		State.CHASE:  _do_chase(delta)
		State.SEARCH: _do_search(delta)

func _do_wander(_delta):
	nav.target_position = wander_target
	_move_toward_nav(wander_speed)
	if nav.is_navigation_finished():
		_pick_wander_target()
	if _can_see_player():
		state = State.CHASE

func _do_chase(_delta):
	if player == null:
		state = State.WANDER
		return
	if player.is_hidden:
		state = State.SEARCH
		search_timer = search_duration
		return
	nav.target_position = player.global_position
	_move_toward_nav(chase_speed)
	if global_position.distance_to(player.global_position) < catch_radius:
		player.die()

func _do_search(delta):
	search_timer -= delta
	if search_timer <= 0:
		state = State.WANDER
		_pick_wander_target()

func _move_toward_nav(spd: float):
	var next = nav.get_next_path_position()
	var dir = (next - global_position)
	dir.y = 0
	dir = dir.normalized()
	velocity = dir * spd
	move_and_slide()

func _can_see_player() -> bool:
	if player == null or player.is_hidden:
		return false
	return global_position.distance_to(player.global_position) < detection_radius

func _pick_wander_target():
	wander_target = global_position + Vector3(
		randf_range(-8, 8),
		0,
		randf_range(-8, 8)
	)
