extends Node3D

class_name Pie

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func addImpulse(impulse):
	print("adding impulse")
	print(impulse)
	var rigidBody = $RigidBody3D
	rigidBody.apply_central_impulse(impulse)
