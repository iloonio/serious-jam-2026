extends RigidBody3D


var hasScored: bool = false

func _on_score_area_3d_body_entered(body: Node3D) -> void:
	if body is RigidBody3D:
		score_goal()


func score_goal():
	if hasScored:
		return
	GameState.add_score(1000)
	hasScored = true
	
