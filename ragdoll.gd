extends Skeleton3D

@onready var rb: RigidBody3D = $RigidBody3D

# Called when the node enters the scene tree for the first time.
func _ready():
	pass

func get_hit():
	physical_bones_start_simulation()
	get_parent().get_parent().get_hit()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	#if Input.is_action_just_pressed("ui_accept"):
	pass

func _physics_process(delta):
	pass
	#print(rb.get_colliding_bodies().size())

#func _on_body_entered(body:Node):
	#physical_bones_start_simulation()
