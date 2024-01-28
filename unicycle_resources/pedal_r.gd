extends Node3D

@onready var r_leg2: Node3D = get_tree().get_nodes_in_group("leg2s")[0]

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var aim = get_parent_node_3d().get_global_transform().basis;
	var up = aim.x
	#first we have the base rotate to face the pedal
	look_at(r_leg2.global_position, up)
	var z = Vector3(0,0,1)
	var x = Vector3(1,0,0)
	rotate_object_local(z, 0.5*PI)
	rotate_object_local(x, -0.5*PI)
	
