extends VehicleBody3D


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	if(Input.is_key_pressed(KEY_W)):
		engine_force = 1
	else:
		engine_force = 0

func _process(delta):
	pass
