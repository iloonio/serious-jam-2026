extends CPUParticles3D

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	transform.rotated(Vector3.UP, deg_to_rad(15))
	


func _on_player_velocity(currentVelocity: float) -> void:
	if(currentVelocity < 0.25):
		hide()
	else: show()
