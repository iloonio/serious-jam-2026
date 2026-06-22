extends AnimationPlayer


func _on_player_is_spinning(flag: bool, speed: float) -> void:
	if flag:
		self.play("spin", -1, speed)
	else:
		self.play("spin", -1, 0)
