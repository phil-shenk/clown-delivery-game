extends Node3D

class_name Level

var pie_scene = preload("res://pie.tscn")
var pie_count = 0
var throw_force = 10.0

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


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
