extends CharacterBody2D

@export_group("Movement")
@export var speed = 300.0
@export var acceleration = 800.0
@export var friction = 600.0

@export_group("Physics")
@export var jump_velocity = -400.0
@export var gravity = 980.0

func _physics_process(delta):
	# Apply Gravity
	if not is_on_floor():
		velocity.y += gravity * delta

	# Handle Jump
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = jump_velocity

	# Get Horizontal Input (-1, 0, 1)
	var direction = Input.get_axis("ui_left", "ui_right")
	
	# Skid-Drive Logic (Acceleration & Friction)
	if direction != 0:
		# Gradually reach target speed
		velocity.x = move_toward(velocity.x, direction * speed, acceleration * delta)
	else:
		# Gradually come to a stop
		velocity.x = move_toward(velocity.x, 0, friction * delta)

	move_and_slide()
