extends Node3D

class_name Pie

# Called when the node enters the scene tree for the first time.
func _ready():
	var rigidBody = $RigidBody3D
	rigidBody.contact_monitor = true
	rigidBody.max_contacts_reported = 100


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func addImpulse(impulse):
	var rigidBody = $RigidBody3D
	rigidBody.apply_central_impulse(impulse)


func _on_rigid_body_3d_body_entered(body: Node3D):
	if body.name == "TargetRigidBody3D":
		body.get_parent().get_hit()
