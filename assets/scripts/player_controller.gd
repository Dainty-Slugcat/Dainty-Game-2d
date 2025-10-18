extends CharacterBody2D

@export var speed = 210.0
@export var jump_power = -300.0
@export var jump_cutoff = 0.3
@export var gravity = 1000.0
@export var jump_buffer_time = 0.2  # secondsaada

@onready var anim_sprite: AnimatedSprite2D = $AnimatedSprite2D

var jump_buffer_timer = 0.0
var current_costume = 0
var was_moving = false

var facing = 1

func _physics_process(delta: float) -> void:
	# Update gravity
	if not is_on_floor():
		velocity.y += gravity * delta

	# Jump buffer
	if Input.is_action_pressed("jump"):
		jump_buffer_timer = jump_buffer_time
	else:
		jump_buffer_timer -= delta

	if is_on_floor() and jump_buffer_timer > 0:
		velocity.y = jump_power
		jump_buffer_timer = 0

	if Input.is_action_just_released("jump") and velocity.y < 0:
		velocity.y *= jump_cutoff

	# Horizontal movement
	var direction = Input.get_axis("move_left", "move_right") #Returns -1 for left, 1 for right
	var is_moving = direction != 0
	
	if direction == 1:
		facing = 1
	elif direction == -1:
		facing = 0
	
	anim_sprite.flip_h = facing #If 0 then faces left, if 1 then faces right

	if is_moving:
		anim_sprite.play("walk")
	else:
		anim_sprite.stop()
		current_costume = 1

	if direction != 0:
		if is_on_floor():
			velocity.x = direction * speed
		else:
			velocity.x = direction * speed * 0.7
	else:
		velocity.x = move_toward(velocity.x, 0, speed)

	was_moving = is_moving

	move_and_slide()
