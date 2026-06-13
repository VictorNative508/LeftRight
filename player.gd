extends CharacterBody2D
class_name Player

@export var speed: float = 325.0
@export var jump_velocity: float = -325.0
@export var acceleration: float = 800
@export var dash_speed: float = 425.0
@export var friction: float = 1100.0
@export var air_resistance: float = 225.0
@export var wall_speed: float = 300.0

@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D

var gravity: float = ProjectSettings.get_setting("physics/2d/default_gravity")
var direction: int = 1
var can_air_dash: bool = false
var can_double_jump: bool = true
var can_wall_jump: bool = true

func _physics_process(delta: float) -> void:
	# Add the gravity.
	handle_gravity(delta)
	handle_jump()
	handle_air_dash()
	handle_short_jump()
	handle_double_jump()
	handle_wall_jump()

	var input_vector: Vector2 = Vector2.ZERO
	input_vector.x = Input.get_axis("left", "right")
	handle_move(input_vector,delta)
	change_direction(input_vector.x)
	update_facing_direction(input_vector.x)

	move_and_slide()

func handle_move(input_vector: Vector2, delta: float) -> void:
	if input_vector.x != 0:
		velocity.x = move_toward(velocity.x, speed * input_vector.x, acceleration * delta)
		if is_on_floor():
			sprite.play("default")
		else:
			if velocity.y > 10.0:
				sprite.play("default")
			else:
				sprite.play("default")
	elif input_vector.x == 0 and not is_on_floor():
		if velocity.y > 10.0:
			sprite.play("default")
		else:
			sprite.play("default")
		velocity.x = move_toward(velocity.x, 0, air_resistance * delta)
	else:
		sprite.play("default")
		can_double_jump = true

		velocity.x = move_toward(velocity.x, 0, friction * delta)

func update_facing_direction(direction: float) -> void:
	if sign(direction) == -1:
		sprite.flip_h = true
	elif sign(direction) == 1:
		sprite.flip_h = false

func change_direction(value: float) -> void:
	direction = sign(value)

func handle_gravity(delta: float) -> void:
	if not is_on_floor():
		velocity.y += gravity * delta

func handle_jump() -> void:
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = jump_velocity
		can_air_dash = true

func handle_air_dash() -> void:
	if Input.is_action_just_pressed("dash") and can_air_dash and not is_on_floor():
		can_air_dash = false
		velocity.x = direction * dash_speed

		if direction:
			velocity.y = jump_velocity * 0.6

func handle_short_jump() -> void:
	if Input.is_action_just_released("jump"):
		if velocity.y < jump_velocity / 3:
			velocity.y = jump_velocity / 3

func handle_double_jump() -> void:
	if can_double_jump and Input.is_action_just_pressed("jump") and not is_on_floor():
		can_double_jump = false
		velocity.y = jump_velocity * 1.1

func handle_wall_jump():
	if can_wall_jump and Input.is_action_just_pressed("jump") and is_on_wall_only():
		var wall_normal: Vector2 = get_wall_normal()
		if wall_normal:
			can_wall_jump = false
			velocity.x = wall_normal.x * wall_speed
			velocity.y = jump_velocity * 1.1