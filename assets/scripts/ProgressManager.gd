extends Node3D

var grassManager : GrassManager

var grassTotal: int
var grassLeft: int


func _ready() -> void:
	grassManager = get_tree().get_first_node_in_group("GrassManager")
	grassManager.updatedGrassDic.connect(update_progress)
	
	grassTotal = grassManager.grassDic.size()
	
	update_progress(grassTotal)



func _physics_process(delta: float) -> void:
	if Input.is_action_just_pressed("Restart Level"):
		get_tree().change_scene_to_file("res://assets/play-scenes/GrassTestStage.tscn")



func update_progress(newGrassAmount) -> void:
	grassLeft = newGrassAmount
	
	%GrassProgressLabel.text = "Grass left: " + str(grassLeft) + "/" + str(grassTotal)
	
	if grassLeft <= 0: 
		level_clear()

func level_clear():
	%GrassProgressLabel.text = "YOU WON, PRESS [R] TO RETRY"
