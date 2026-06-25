extends Node3D



func _on_area_3d_body_entered(body: Node3D) -> void:
	if "Player" in body.get_groups():
		%TextAnimationPlayer.play("pop_up")

func _on_area_3d_body_exited(body: Node3D) -> void:
	if "Player" in body.get_groups(): # Replace with function body.
		%TextAnimationPlayer.play("pop_down")
