extends CharacterBody3D


## Movement Parameters
@export var speed: float = 7.0
@export var jump_velocity: float = 4.5
@export var gravity: float = 9.8

## Parkour Parameters
@export var max_jumps: int = 2
@export var vault_height: float = 1.5
@export var vault_speed: float = 8.0

# Tracking jumps
var jump_count: int = 0

# Vaulting state
var is_vaulting: bool = false
var vault_target_position: Vector3 = Vector3.ZERO

func _ready() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE

func _physics_process(delta: float) -> void:

	# 2. Add Gravity
	if not is_on_floor():
		velocity.y -= gravity * delta
	else:
		jump_count = 0 # Reset jump counter on land

	# 3. Handle Jump / Double Jump
	if Input.is_action_just_pressed("jump"):
		if is_on_floor():
			velocity.y = jump_velocity
			jump_count = 1
		elif jump_count < max_jumps:
			velocity.y = jump_velocity
			jump_count += 1

	# 5. Handle standard horizontal movement
	var input_dir := Input.get_vector("left", "right", "up", "down")
	var direction := (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	
	if direction:
		velocity.x = direction.x * speed
		velocity.z = direction.z * speed
	else:
		velocity.x = move_toward(velocity.x, 0, speed)
		velocity.z = move_toward(velocity.z, 0, speed)
	move_and_slide()
