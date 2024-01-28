extends Node3D

@onready var aN: Node3D = $r_leg
@onready var bN: Node3D = $r_leg/r_leg2
@onready var cN: Node3D = get_tree().get_nodes_in_group("pedals")[0]


#       o aN
#      / \
#   b /  c\ 
#    /   . o bN
#cN o  `a



#a = bN to cN
var a: float
#b = aN to cN
var b: float
#c = aN to bN
var c: float

#squared vals
var aSq: float
var bSq: float
var cSq: float

#angles
var A: float
var B: float


# Called when the node enters the scene tree for the first time.
func _ready():
	
	#a and c won't change
	a = (cN.global_position - bN.global_position).length()
	c = (bN.global_position - aN.global_position).length()
	
	aSq = a * a
	cSq = c * c


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	#var up = Vector3(0, 0, -1)
	var aim = get_parent_node_3d().get_global_transform().basis;
	var up = -aim.z
	#first we have the base rotate to face the pedal
	look_at(cN.global_position, up)
	 
	#run calculations for values
	b = (cN.global_position - aN.global_position).length()
	bSq = b * b
	
	var locA = acos((bSq + cSq - aSq) / (2 * b * c))
	#var locC = acos((aSq + bSq - cSq) / (2 * a * b))
	var locB = acos((cSq + aSq - bSq) / (2 * c * a))
	
	#aN.rotate_object_local(Vector3(1, 0, 0), locA)
	#bN.rotate_object_local(Vector3(1, 0, 0), locB)
	
	aN.rotation.x = PI*0.5 - locA
	bN.rotation.x = PI - locB
	
	#print("cN.position" + str(cN.global_position))
	
