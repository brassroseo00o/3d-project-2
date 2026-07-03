extends CharacterBody3D


## Movement Parameters
@export var speed: float = 5.0
@export var jump_velocity: float = 5
@export var gravity: float = 10

## Parkour Parameters
@export var max_jumps: int = 2
@export var vault_height: float = 3
@export var vault_speed: float = 8.0

# Tracking jumps
var jump_count: int = 0

# Vaulting state
var is_vaulting: bool = false
var vault_target_position: Vector3 = Vector3.ZERO


@onready var camera = $Camera3D # Ensure the node name matches

@export var mouse_sensitivity := 0.1
@export var tilt_upper_limit := 89.0
@export var tilt_lower_limit := -90.0
var camera_rotation_x:= 0.0

func _ready():
	# Keeps the cursor hidden and centered
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED

func _unhandled_input(event):
	if event is InputEventMouseMotion:
		camera_rotation_x -= event.relative.x * mouse_sensitivity
	camera.rotation.x = camera_rotation_x
		# 1. Rotate the whole Player body horizontally (Y-axis)
	rotate_y(deg_to_rad(-event.relative.y * mouse_sensitivity))
		
		# 2. Rotate the Camera vertically (X-axis)
	camera.rotate_x(deg_to_rad(-event.relative.x * mouse_sensitivity))
		
		# 3. Clamp the vertical look so you can't flip upside down
	camera.rotation.x = clamp(camera.rotation.x, deg_to_rad(tilt_lower_limit), deg_to_rad(tilt_upper_limit))
	
	# Press ESC to regain mouse control
	if event.is_action_pressed("ui_cancel"):
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
