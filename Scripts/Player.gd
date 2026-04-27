extends CharacterBody2D

@onready var sprite = $AnimatedSprite2D

@export_group("Movement")
@export var speed = 800.0
@export var acceleration = 2000.0
@export var friction = 1500.0

@export_group("Physics")
@export var jump_velocity = -1000.0
@export var gravity = 2500.0

@export_group("Feel")
@export var coyote_time = 0.15
@export var jump_buffer_time = 0.1

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
		coyote_timer = coyote_time

	# Handle Jump Input & Buffering
	if Input.is_action_just_pressed("ui_accept"):
		jump_buffer_timer = jump_buffer_time

	# Execute Jump
	if jump_buffer_timer > 0 and coyote_timer > 0:
		velocity.y = jump_velocity
		jump_buffer_timer = 0.0
		coyote_timer = 0.0

	# Get Horizontal Input
	var direction = Input.get_axis("ui_left", "ui_right")
	
	if direction != 0:
		velocity.x = move_toward(velocity.x, direction * speed, acceleration * delta)
		sprite.play("move")
		sprite.flip_h = direction < 0
	else:
		velocity.x = move_toward(velocity.x, 0, friction * delta)
		if abs(velocity.x) < 1.0:
			sprite.play("idle")

	move_and_slide()
