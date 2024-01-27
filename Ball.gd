extends RigidBody3D


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _physics_process(delta):
	var movement_vector = Vector3()
	if(Input.is_key_pressed(KEY_W)):
		movement_vector += Vector3(0,0,-0.01)
	if(Input.is_key_pressed(KEY_S)):
		movement_vector += Vector3(0,0,0.01)
	if(Input.is_key_pressed(KEY_A)):
		movement_vector += Vector3(-0.01,0,0)
	if(Input.is_key_pressed(KEY_D)):
		movement_vector += Vector3(0.01,0,0)
		
	move_and_collide(movement_vector)
