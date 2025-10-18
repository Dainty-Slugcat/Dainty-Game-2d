extends CharacterBody2D

@export var speed = 210.0
@export var jump_power = -300.0
@export var jump_cutoff = 0.3
@export var gravity = 1000.0
@export var jump_buffer_time = 0.2  # seconds

var jump_buffer_timer = 0.0

func _physics_process(delta: float) -> void:
	# Update gravity
	if not is_on_floor():
		velocity.y += gravity * delta

	# Jump buffer: store how long jump has been held
	if Input.is_action_pressed("jump"):
		jump_buffer_timer = jump_buffer_time
	else:
		jump_buffer_timer -= delta

	# Allow jump if grounded AND jump was recently pressed (or still held)
	if is_on_floor() and jump_buffer_timer > 0:
		velocity.y = jump_power
		jump_buffer_timer = 0  # Prevent repeated jumping while holding

	# Cut jump short if released early
	if Input.is_action_just_released("jump") and velocity.y < 0:
		velocity.y *= jump_cutoff

	# Left/right movement
	var direction = Input.get_axis("move_left", "move_right")
	play("walk")
	if direction != 0:
		if is_on_floor():
			velocity.x = direction * speed
		else:
			velocity.x = direction * speed * 0.7
	else:
		velocity.x = move_toward(velocity.x, 0, speed)

	move_and_slide()
