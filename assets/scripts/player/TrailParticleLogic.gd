extends CPUParticles3D

var player: RigidBody3D


func _ready() -> void:
	player = get_tree().get_first_node_in_group("Player")
	

func _physics_process(delta: float) -> void:
	rotation.y = Vector2(player.angular_velocity.x, player.angular_velocity.z).angle()



func _on_player_velocity(currentVelocity: float) -> void:
	if(currentVelocity < 0.25):
		emitting = false
	else: emitting = true
