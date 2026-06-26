extends RigidBody3D


func _integrate_forces(state: PhysicsDirectBodyState3D) -> void:
	%TrailParticles3D.position = position
	
	if state.linear_velocity.length() >= 0.5:
		%TrailParticles3D.emitting = true
	else:
		%TrailParticles3D.emitting = false
