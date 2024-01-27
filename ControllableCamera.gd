extends Node3D

class_name ControllableCamera

@export var min_pitch: float = -90
@export var max_pitch: float = 75
@export var zoom_step: float = .05
@export var sensitivity: float = 0.1

@export var rotate_speed: float = 10
@export var zoom_speed: float = 10
@export var min_distance: float = 2
@export var max_distance: float = 7

var _cam_rot: Vector2 = Vector2.ZERO
var _zoom_scale: float = 0

@onready var _gimbal_h: Node3D = $GimbalH
@onready var _gimbal_v: Node3D = $GimbalH/GimbalV
@onready var _camera: Camera3D = $GimbalH/GimbalV/Camera3D
@onready var _player: Player = get_tree().get_nodes_in_group("player")[0]

var _rot_h: float = 0
var _rot_v: float = 0
var _distance: float = 0

func _ready():
	# wait until the parent node is ready
	await get_parent().ready

	# set the current distance to the camera's current local Z position
	_distance = _camera.transform.origin.z

	# schedule a call for the _initialize_zoom_scale method checked the next idle frame
	call_deferred("_initialize_zoom_scale")

func _initialize_zoom_scale():
	# calculate the initial zoom scale based checked the camera's current distance and the distance range
	# and set the controls node's current zoom scale value to that value
	var initial_zoom_scale := (_distance - min_distance) / (max_distance - min_distance)
	_zoom_scale = initial_zoom_scale

func _process(delta):
	# get the camera's current horizontal and vertical rotation angles and assign them to local fields
	
	_rot_h = _cam_rot.x
	_rot_v = _cam_rot.y

	# calculate the target camera distance based checked the zoom scale value of the controls node and the
	# distance range
	_distance = _zoom_scale * (max_distance - min_distance) + min_distance

func _physics_process(delta):
	# lerp the the horizontal and vertical gimbals' rotations towards the corresponding rotation angles
	# note that we're using lerp instead of lerp_angle because the latter tries to determine the rotation
	# direction based checked the current and target values, which would cause the camera to twitch around
	# the current value and not reach the target value
	_gimbal_h.rotation.y = lerpf(_gimbal_h.rotation.y, deg_to_rad(_rot_h), rotate_speed * delta)
	_gimbal_v.rotation.x = lerpf(_gimbal_v.rotation.x, deg_to_rad(_rot_v), rotate_speed * delta)

	# lerp the camera's current local Z position towards the distance variable as determined by the
	# controls node's zoom scale value in the _process method
	_camera.transform.origin.z = lerpf(_camera.transform.origin.z, _distance, zoom_speed * delta)

