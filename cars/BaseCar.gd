extends VehicleBody3D

@export var patrol_path: Path3D
@export var engine_force_value = 15
var patrol_points
var patrol_index = 0

func _ready():
	patrol_path = get_parent().get_node("CarPath"+name)
	if patrol_path:
		patrol_points = patrol_path.curve.get_baked_points()
		set_engine_force(engine_force_value)

func _physics_process(delta: float) -> void:
	if !patrol_path:
		return
	var steer_target = patrol_points[patrol_index]
	if position.distance_to(steer_target) < 8:
		#print("short distance "+str(position.distance_to(steer_target)))
		patrol_index = wrapi(patrol_index + 1, 0, patrol_points.size())
		steer_target = patrol_points[patrol_index]
	var target_vector = (steer_target-position).normalized()
	var target_angle = atan2(target_vector.x, target_vector.z)

	var forward = global_transform.basis.z
	var car_global_angle = atan2(forward.x, forward.z)
	
	var relative_angle = wrapf(target_angle - car_global_angle, -PI, PI)
	if (steer_target-position).length() < 1:
		relative_angle = 0

	var new_steering = relative_angle / 4
	if abs(new_steering) > PI/3:
		new_steering = sign(new_steering) * PI / 3
	steering = new_steering
	
	if abs(relative_angle) > PI/12:
		set_engine_force(engine_force_value*0.3)
	elif abs(relative_angle) > PI/18:
		set_engine_force(engine_force_value*0.8)
	else:
		set_engine_force(engine_force_value)

	#print("position " + str(position))
	#print("destination " + str(patrol_points[patrol_index]))
	#print("target vector "+str(target_vector) + " relative to car")
	#print("car velocity " + str(linear_velocity) + " length " + str(linear_velocity.length()) + " engine force "+str(engine_force))
	#print("steering " + str(steering))
	#print("target angle " + str(target_angle))
	#print("car angle "+str(car_global_angle))
	#print("target (relative) angle: "+str(relative_angle))
	#print("angular velocity: "+str(angular_velocity.y))
