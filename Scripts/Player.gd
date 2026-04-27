extends CharacterBody2D

@export_group("Movement")
@export var speed = 300.0
@export var acceleration = 800.0
@export var friction = 600.0

@export_group("Physics")
@export var jump_velocity = -400.0
@export var gravity = 980.0

@export_group("Feel")
@export var coyote_time = 0.15 # Seconds to allow jump after leaving ledge
@export var jump_buffer_time = 0.1 # Seconds to "remember" jump press before landing

var coyote_timer = 0.0
var jump_buffer_timer = 0.0

func _physics_process(delta):
	# Handle Timers
	coyote_timer -= delta
	jump_buffer_timer -= delta

	# Apply Gravity
	if not is_on_floor():
		velocity.y += gravity * delta
	else:
		coyote_timer = coyote_time # Reset coyote time while on floor

	# Handle Jump Input & Buffering
	if Input.is_action_just_pressed("ui_accept"):
		jump_buffer_timer = jump_buffer_time

	# Execute Jump (Coyote Time + Buffering)
	if jump_buffer_timer > 0 and coyote_timer > 0:
		velocity.y = jump_velocity
		jump_buffer_timer = 0.0 # Clear buffer
		coyote_timer = 0.0 # Clear coyote

	# Get Horizontal Input
	var direction = Input.get_axis("ui_left", "ui_right")
	
	if direction != 0:
		velocity.x = move_toward(velocity.x, direction * speed, acceleration * delta)
	else:
		velocity.x = move_toward(velocity.x, 0, friction * delta)

	move_and_slide()
