extends Node3D


func _on_to_level_1_body_entered(body: Node3D) -> void:
	if "Player" in body.get_groups():
		SceneManager.load_scene("res://assets/play-scenes/levels/Level1.tscn")


func _on_to_level_2_body_entered(body: Node3D) -> void:
	if "Player" in body.get_groups():
		SceneManager.load_scene("res://assets/play-scenes/levels/Level2.tscn")


func _on_to_level_3_body_entered(body: Node3D) -> void:
	if "Player" in body.get_groups():
		SceneManager.load_scene("res://assets/play-scenes/levels/Level3.tscn")
