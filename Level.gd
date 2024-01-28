extends Node3D

class_name Level

var pie_scene = preload("res://pie.tscn")
var pie_count = 0
var throw_force = 0.0
var targets_hit = 0
const min_throw_force = 5.0
const max_throw_force = 100.0
const throw_force_scaling = 10.0


# Called when the node enters the scene tree for the first time.
func _ready():
	print("READY")
	pass # Replace with function body.

func _input(delta):
	pass
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var forceBar = $UICanvasLayer/ThrowForceBar

	if(Input.is_action_just_pressed("throw_pie")):
		# reset throw force
		throw_force = 0.0
	
	if(Input.is_action_pressed("throw_pie")):
		throw_force += throw_force_scaling*delta
		throw_force = clampf(throw_force, min_throw_force, max_throw_force)
		print(throw_force)
		
		forceBar.polygon[1].x = throw_force * 10.0 + 5.0
		forceBar.polygon[2].x = throw_force * 10.0 + 5.0
			
	if(Input.is_action_just_released("throw_pie")):
		# reset throw force, and throw it
		throwFood()
		print(throw_force)
		throw_force = 0.0
		forceBar.polygon[1].x = throw_force * 10.0 + 10.0
		forceBar.polygon[2].x = throw_force * 10.0 + 10.0
	
	var new_targets_hit = count_targets_hit()
	if new_targets_hit > targets_hit:
		targets_hit = new_targets_hit
		print("new target hit! count is now ", new_targets_hit)
	


func throwFood():
	var player := $Player
	var pie_instance : Pie = pie_scene.instantiate()
	pie_count += 1
	print(pie_count)
	
	pie_instance.position = player.position + Vector3(0,1.2,0)
	
	var camera := $CamRoot/ControllableCamera
	var camera_direction = -camera._camera.get_global_transform().basis.z
	
	#var player_direction = -player.global_transform.basis.z
	var throw_direction = (camera_direction + Vector3(0,0.8,0)).normalized()
	pie_instance.addImpulse(throw_direction * throw_force)
	add_child(pie_instance)


func count_targets_hit() -> int:
	var hit_count = 0
	for child in get_children():
		if child.has_node("TargetRigidBody3D"):
			if child.was_hit:
				hit_count += 1
	return hit_count
