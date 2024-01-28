extends Node3D

@onready var aN: Node3D = $l_leg
@onready var bN: Node3D = $l_leg/l_leg2
@onready var cN: Node3D = get_tree().get_nodes_in_group("pedals")[0]
@onready var cNB: Node3D = get_tree().get_nodes_in_group("pedals")[1]



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
	look_at(cNB.global_position, up)
	 
	#run calculations for values
	b = (cN.global_position - aN.global_position).length()
	bSq = b * b
	
	var locA = (bSq + cSq - aSq) / (2 * b * c)
	#var locC = acos((aSq + bSq - cSq) / (2 * a * b))
	var locB = (cSq + aSq - bSq) / (2 * c * a)
	print("locB1 " + str(locB))
	#my problem is that if locA or locB > 1.0 then we get NaN error from Acos
	#so we need to flip the triangle logic accordingly
	if absf(locA) > 1:
		if locA < 0:
			locA += 2
			locA *= -1
		else: 
			locA -= 2
			locA *= -1
	if absf(locB) > 1:
		if locB < 0:
			locB += 2
			locB *= -1
		else: 
			locB -= 2
			locB *= -1
	
	
	#aN.rotate_object_local(Vector3(1, 0, 0), locA)
	#bN.rotate_object_local(Vector3(1, 0, 0), locB)
	
	aN.rotation.x = acos(locA)
	bN.rotation.x =  acos(locB) - PI*0.25
	
	print("cN.position " + str(cN.global_position))
	print("locB2 " + str(locB))
	
