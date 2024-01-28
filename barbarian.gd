extends Node3D
class_name Barbarian

@export var was_hit = false

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func get_hit():
	if not was_hit:
		print("Ouch!")
	was_hit = true

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
