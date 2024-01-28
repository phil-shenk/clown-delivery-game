extends CharacterBody3D

class_name Player

@export var speed: float = 5.0
@export var jump_velocity: float = 4.5

@export var pedal_speed_added: float = 3
@export var forward_drag: float = 0.5
@export var side_move_reduce_coeff: float = 0.5
@export var acceleration: float = 5
@export var cam_follow_speed: float = 8

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")

var _is_capturing: bool = true

var input_dir = Vector3.ZERO
var direction = Vector3.ZERO
var move_rot: float = 0


@onready var camera: ControllableCamera = get_tree().get_nodes_in_group("camera")[0]
@onready var mesh: Node3D = $MeshModel

var new_velocity: Vector3 = Vector3.ZERO

var rotation_amount: float = 0
@export var rotation_amount_coeff: float = 0.1
@export var turn_speed: float = 20
var new_forward_speed: float = 0
var input_x_turn_delay: float = 0

func _ready():
	if _is_capturing:
		print("ENABLED MOUSE CAPTURE")
		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	else:
		print("DISABLED MOUSE CAPTURE")
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	
func _input(event):
	# focus on pie-throwing
	camera.isAiming = Input.is_action_pressed("aim_pie")
	
	# toggle the mouse cursor's capture mode when the ui_cancel action is
	# pressed (e.g. the Esc key)
	if Input.is_action_just_pressed("ui_cancel"):
		_is_capturing = !_is_capturing

		if _is_capturing:
			print("ENABLED MOUSE CAPTURE")
			Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
		else:
			print("DISABLED MOUSE CAPTURE")
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

	if Input.is_key_pressed(KEY_F):
		# toss some food for good measure
		var parentLevel : Level = get_parent()
		parentLevel.throwFood()
		
	if Input.is_key_pressed(KEY_B):
		teleport_to_baltimore()

func teleport_to_baltimore():
	#var child_node = get_node("path/to/child")
	var tree = get_tree()
	var camRoot = get_parent().get_node("CamRoot")
	get_parent().remove_child(camRoot)
	get_parent().remove_child(self)
	print(camRoot)
	print(camRoot)

	
	# Queue the current scene to free on the next frame:
	#var root_node = get_tree().get_root()
	#var scene_node = root_node.get_node("Level1")
	#scene_node.queue_free()

	# Load in some scene from our project files:
	#var new_scene_resource = load("res://Levels/Level2.tscn") # Load the new level from disk
	#var new_scene_node = new_scene_resource.instantiate() # Create an actual node of it for the game to use
	#root_node.add_child(new_scene_node) # Add to the tree so the level starts processing
	#get_node("path/to/new/parent").add_child(child_node)
	tree.change_scene_to_file("res://Baltmore.tscn")
	tree.current_scene.add_child(self)
	tree.current_scene.add_child(camRoot)
	
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
	#direction = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	
	
	
	#if direction:
		#velocity.x = direction.x
		#velocity.z = velocity.z + abs(direction.x * pedal_speed_added) - (forward_drag * delta)
	
	set_new_velocity(delta)
	velocity = Vector3(new_velocity.x, velocity.y, new_velocity.z)
	
	#print("velocity: " + str(velocity))
	
	move_and_slide()
	
  
func set_new_velocity(delta):
	
	# make the player move towards where the camera is facing by lerping the current movement rotation
	# towards the camera's horizontal rotation and rotating the raw movement direction with that angle
	#move_rot = lerpf(move_rot, deg_to_rad(camera._rot_h), cam_follow_speed * delta)
	#direction = direction.rotated(Vector3.UP, move_rot)
	
	#reduce side to side power
	#direction.x = direction.x * side_move_reduce_coeff
	
	#var aim = get_global_transform().basis;
	#var forward_velocity = aim.z * velocity.length()
	
	# Rotate around the object's local Y axis by 0.1 radians.
	#rotate_object_local(Vector3(0, 1, 0), 0.1)
	
	var prev_velocity = velocity
	prev_velocity.y = 0
	
	input_x_turn_delay = lerpf(input_x_turn_delay, input_dir.x, turn_speed * delta)
	
	rotation_amount = -input_x_turn_delay
	
	rotate_object_local(Vector3(0, 1, 0), rotation_amount * rotation_amount_coeff)
	
	
	var total_drag = prev_velocity.length() * delta * forward_drag
	new_forward_speed = prev_velocity.length() + (abs(input_x_turn_delay) * pedal_speed_added * delta) - total_drag
	
	var aim = get_global_transform().basis;
	new_velocity = aim.z * new_forward_speed
	
	
	

	#forward_velocity = forward_velocity.normalized() * (forward_velocity.length() + abs(direction.x * pedal_speed_added) - total_drag)
	#if forward_velocity.z < 0:
	#	forward_velocity.z = 0

	var move_dir = Vector2(direction.x, direction.z)

