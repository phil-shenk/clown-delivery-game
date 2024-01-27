extends CharacterBody3D

class_name Player

@export var speed: float = 5.0
@export var jump_velocity: float = 4.5
@export var turn_speed: float = 8
@export var acceleration: float = 5
@export var cam_follow_speed: float = 8

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")

var _is_capturing: bool = false

var input_dir = Vector3.ZERO
var direction = Vector3.ZERO
var move_rot: float = 0


@onready var camera: ControllableCamera = $CamRoot/ControllableCamera
@onready var mesh: Node3D = $MeshModel

var horizontal_velocity: Vector3 = Vector3.ZERO


func _input(event):
	# toggle the mouse cursor's capture mode when the ui_cancel action is
	# pressed (e.g. the Esc key)
	if Input.is_action_just_pressed("ui_cancel"):
		_is_capturing = !_is_capturing

		if _is_capturing:
			Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
		else:
			Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)

	# if the mouse cursor is being captured, update the camera rotation using the relative movement
	# and the sensitivity we defined earlier. also clamp the vertical camera rotation to the pitch
	# range we defined earlier so we don't end up in weird look angles
	if _is_capturing && event is InputEventMouseMotion:
		camera._cam_rot.x -= event.relative.x * camera.sensitivity
		camera._cam_rot.y -= event.relative.y * camera.sensitivity
		camera._cam_rot.y = clamp(camera._cam_rot.y, camera.min_pitch, camera.max_pitch)

	# if the mouse cursor is being captured, increse or decrease the zoom when the corresponding
	# action has just been pressed
	if _is_capturing:
		if Input.is_action_just_pressed("zoom_in"):
			camera._zoom_scale = clamp(camera._zoom_scale - camera.zoom_step, 0, 1)
		if Input.is_action_just_pressed("zoom_out"):
			camera._zoom_scale = clamp(camera._zoom_scale + camera.zoom_step, 0, 1)


func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y -= gravity * delta

	# Handle jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = jump_velocity

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	input_dir = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	direction = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	
	
	
	if direction:
		velocity.x = direction.x
		velocity.z = direction.z
	
	set_horizontal_movement(speed, turn_speed, cam_follow_speed, acceleration, delta)
	velocity = Vector3(horizontal_velocity.x, velocity.y, horizontal_velocity.z)
	
	move_and_slide()
	


func set_horizontal_movement(speed, turn_speed, cam_follow_speed, acceleration, delta):
	
	var move_dir = Vector2(direction.x, direction.z)

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
