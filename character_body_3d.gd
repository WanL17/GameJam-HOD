extends CharacterBody3D

@export var SPEED = 5.0
@export var JUMP_VELOCITY = 4.5
@export var MOUSE_SENSITIVITY = 0.003

# On récupère la référence de la tête et de la caméra
@onready var head = $Head
@onready var camera = $Head/Camera3D

func _ready():
	# Capture la souris pour qu'elle ne sorte pas de la fenêtre du jeu
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _unhandled_input(event):
	# Si la souris bouge
	if event is InputEventMouseMotion:
		# Pivot gauche/droite du corps complet
		rotate_y(-event.relative.x * MOUSE_SENSITIVITY)
		
		# Pivot haut/bas de la tête uniquement
		head.rotate_x(-event.relative.y * MOUSE_SENSITIVITY)
		
		# On limite la vision pour ne pas pouvoir faire un backflip avec les yeux
		head.rotation.x = clamp(head.rotation.x, deg_to_rad(-89), deg_to_rad(89))

func _physics_process(delta):
	# Ajout de la gravité (géré de base par Godot)
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Gestion du saut (Optionnel pour un jeu narratif)
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Récupération des directions avec ZQSD (ou les flèches par défaut de Godot)
	var input_dir = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	
	# IMPORTANT : On se déplace par rapport à la direction où regarde le joueur
	var direction = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	
	if direction:
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)

	move_and_slide()
