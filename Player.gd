extends CharacterBody3D

class_name Player

const SPEED = 5.0
const JUMP_VELOCITY = 4.5

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")

var input_dir = Vector3.ZERO
var direction = Vector3.ZERO
var move_rot: float = 0

#TO-DO: add controllable camera script
@onready var camera
@onready var mesh: Node3D = $MeshModel

var horizontal_velocity: Vector3 = Vector3.ZERO


func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y -= gravity * delta

	# Handle jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	input_dir = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	direction = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)

	move_and_slide()
	


func set_horizontal_movement(speed, turn_speed, cam_follow_speed, acceleration, delta):
	# get the movement direction directly from the controls node and turn it into a Vector3
	var move_dir = direction
	var direction = Vector3(move_dir.x, 0, move_dir.y)

	# make the player move towards where the camera is facing by lerping the current movement rotation
	# towards the camera's horizontal rotation and rotating the raw movement direction with that angle
	move_rot = lerpf(move_rot, deg_to_rad(camera._rot_h), cam_follow_speed * delta)
	direction = direction.rotated(Vector3.UP, move_rot)

	# lerp the player's current horizontal velocity towards the horizontal velocity as determined by
	# the input direction and the given horizontal speed
	horizontal_velocity = lerp(horizontal_velocity, direction * speed, acceleration * delta)

	# if the player has any amount of movement, lerp the player model's rotation towards the current
	# movement direction based checked its angle towards the X+ axis checked the XZ plane
	if move_dir != Vector2.ZERO:
		#TO-DO: add mesh model rotation here
		mesh.rotation.y = lerp_angle(mesh.rotation.y, atan2(-direction.x, -direction.z), turn_speed * delta)
		pass
