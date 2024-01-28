extends StaticBody3D


# Called when the node enters the scene tree for the first time.
func _ready():
	var mesh = $small_buildingA_testExport/tmpParent/small_buildingA
	#print(mesh)
	var collision_shape := $CollisionShape3D
	var concave_polygon : ConcavePolygonShape3D = collision_shape.shape
	concave_polygon.set_faces(mesh.get_mesh().get_faces())
	
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
