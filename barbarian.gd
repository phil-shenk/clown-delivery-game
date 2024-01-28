extends Node3D
class_name Barbarian

@export var was_hit = false
var is_close = false
var animation_player: AnimationPlayer

# Called when the node enters the scene tree for the first time.
func _ready():
	animation_player = $AnimationPlayer

func get_hit():
	if not was_hit:
		animation_player.play("Death_A")
		print("Ouch!")
	was_hit = true

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if not was_hit:
		var player_node = get_parent().get_node("Player")
		if position.distance_to(player_node.position) < 10:
			if not is_close:
				animation_player.play("Jump_Full_Short")
			is_close = true
		else:
			if is_close:
				animation_player.play("idle")
			is_close = false
