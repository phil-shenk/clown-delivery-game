extends Node3D

class_name Level

var pie_scene = preload("res://pie.tscn")
var pie_count = 0
var throw_force = 0.0
var targets_hit = 0
const min_throw_force = 5.0
const max_throw_force = 100.0
const throw_force_scaling = 10.0

var scoreLabel

# could also use @onready
var camera : ControllableCamera
var forceBar
var aimPath
var aimPathPolygon
var player
const AIM_PATH_POINTS = 32

@onready var honk_sound: AudioStreamPlayer3D = $honk_sound1
@onready var honk_sound2: AudioStreamPlayer3D = $honk_sound2

# Called when the node enters the scene tree for the first time.
func _ready():
	scoreLabel = $UICanvasLayer/ScoreLabel
	camera = $CamRoot/ControllableCamera
	forceBar = $UICanvasLayer/ThrowForceBar
	aimPath = $Player/AimPath3D
	aimPathPolygon = $Player/AimPathPolygon
	player = $Player
	
	aimPathPolygon.set_visible(false)
	# initialize the path
	aimPath.curve.clear_points()
	for i in range(AIM_PATH_POINTS):
		aimPath.curve.add_point(Vector3(i,0,0))
		
	print("READY")

func _input(delta):
	pass
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):

	if(Input.is_action_just_pressed("throw_pie")):
		# reset throw force
		throw_force = 0.0
		
		# show path3d for rangefinding
		aimPathPolygon.set_visible(true)
		honk_sound.play()
		
	
	if(Input.is_action_pressed("throw_pie")):
		throw_force += throw_force_scaling*delta
		throw_force = clampf(throw_force, min_throw_force, max_throw_force)
		#print(throw_force)
		
		forceBar.polygon[1].x = throw_force * 10.0 + 5.0
		forceBar.polygon[2].x = throw_force * 10.0 + 5.0
		
		# calculate parabola for path3d
		var throw_direction = getThrowDirection()
		var angle = PI/2.0 - throw_direction.angle_to(Vector3(0,1,0))

		var g = 9.8
		var y0 = player.position.y
		var v = throw_force * 1.0 # need to find scaling
		var distance = v*cos(angle) * (v*sin(angle) + sqrt(v**2 * sin(angle) + 2*g*y0)) / g
		#print(distance)
		
		for i in range(AIM_PATH_POINTS):
			# need evenly-spaced x points from 0 to distance
			var x = i * (distance/AIM_PATH_POINTS)
			# need value of parabola at each x point
			var t = x/(v*cos(angle))

			var y = y0 + v*t*sin(angle) - 0.5*g*(t**2)
			if(is_nan(x)):
				x = 0
			if(is_nan(y)):
				y = 0
			var point = Vector3(0, y, x)

			aimPath.curve.set_point_position(i, point)
			
		aimPathPolygon.rotation = Vector3(0,camera.y_rotation + PI - player.rotation.y,0)
		
		throw_force
		
			
	if(Input.is_action_just_released("throw_pie")):
		honk_sound2.play()
		# reset throw force, and throw it
		throwFood()
		#print(throw_force)
		throw_force = 0.0
		forceBar.polygon[1].x = throw_force * 10.0 + 10.0
		forceBar.polygon[2].x = throw_force * 10.0 + 10.0
	
		# clear path3d data (or just hide it)
		aimPathPolygon.set_visible(false)

	var new_targets_hit = count_targets_hit()
	if new_targets_hit > targets_hit:
		targets_hit = new_targets_hit
		print("new target hit! count is now ", new_targets_hit)
		scoreLabel.text = "Score: "+str(targets_hit)


func throwFood():
	var pie_instance : Pie = pie_scene.instantiate()
	pie_count += 1
	print("pies thrown: ", pie_count)
	
	pie_instance.position = player.position + Vector3(0,1.2,0)
	
	var throw_direction = getThrowDirection()
	
	pie_instance.addImpulse(throw_direction * throw_force)

	add_child(pie_instance)
	
func getThrowDirection():
	var camera_direction = -camera._camera.get_global_transform().basis.z
	
	#var player_direction = -player.global_transform.basis.z
	return (camera_direction + Vector3(0,0.8,0)).normalized()


func count_targets_hit() -> int:
	var hit_count = 0
	for child in get_children():
		if child.has_node("TargetRigidBody3D"):
			if child.was_hit:
				hit_count += 1
	return hit_count
