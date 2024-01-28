extends Node3D

@onready var r_leg: Node3D = $r_leg
@onready var r_leg2: Node3D = $r_leg/r_leg2
@onready var pedal: Node3D = get_tree().get_nodes_in_group("pedals")[0]

var aN: Node3D
var bN: Node3D

# Called when the node enters the scene tree for the first time.
func _ready():
	aN = r_leg


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
