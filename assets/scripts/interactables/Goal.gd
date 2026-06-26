extends RigidBody3D
@export var goalScore: int = 1000

var hasScored: bool = false

func _on_score_area_3d_body_entered(body: Node3D) -> void:
	if body is RigidBody3D:
		score_goal()


func score_goal():
	if hasScored:
		return
	
	GameState.add_score(goalScore)
	hasScored = true
	%ScoreLabel3D.text = "+" + str(goalScore)
	%AnimationPlayer.play("show_score")
	
	var fx: PackedScene = load("res://assets/prefabs/particle-fx/ExplosionFX.tscn")
	var fxInstance: CPUParticles3D = fx.instantiate()
	fxInstance.propagate_call("set", ["one_shot", true])
	
	add_child(fxInstance)
