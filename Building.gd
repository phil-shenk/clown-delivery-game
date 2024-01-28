extends StaticBody3D

class_name Building

var meshInstance3D: MeshInstance3D

func initialize_mesh(meshInstance3D):
	if(meshInstance3D):
		var mesh = meshInstance3D.mesh
		
		print(mesh)
		var collision_shape := $CollisionShape3D
		var concave_polygon : ConcavePolygonShape3D = collision_shape.shape
		concave_polygon.set_faces(mesh.get_faces())


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
