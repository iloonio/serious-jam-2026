extends RigidBody3D
@export var slayScore: int = 1000




func _on_breakable_component_on_break() -> void:
	
	var scoreLabel: PackedScene = load("res://assets/prefabs/ScoreLabel.tscn")
	var scoreLabelInstance: Label3D = scoreLabel.instantiate()
	
	GameState.add_score(slayScore)
	scoreLabelInstance.text = "+" + str(slayScore)
	#scoreLabelInstance.position += get_parent().position 

	
	get_tree().get_first_node_in_group("Player").add_child(scoreLabelInstance)
