extends Skeleton3D

@onready var rb: RigidBody3D = $RigidBody3D

# Called when the node enters the scene tree for the first time.
func _ready():
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_action_just_pressed("ui_accept"):
		physical_bones_start_simulation()

func _physics_process(delta):
	print(rb.get_colliding_bodies().size())

func _on_body_entered(body:Node):
	physical_bones_start_simulation()
