extends Node3D


## The displayed text before clearing the related stage
@export_multiline var preStageText: String

## Choose after which stage "Post Stage Text" will be shown
@export_enum("Level1", "Level2", "Level3") var relatedStage: String = "Level 1"

## The displayed text after clearing the related stage
@export_multiline var postStageText: String

## The displayed text after clearing all stages
@export_multiline var clearAllText: String



func _ready() -> void:
	
	## check if all stages are cleared
	if clearAllText != "" and (GameState.levelStats["level1"]["isCleared"] and GameState.levelStats["level2"]["isCleared"] and GameState.levelStats["level3"]["isCleared"]):
		%Label3D.text = clearAllText
	
	
	## check related stage is cleared
	elif GameState.levelStats[relatedStage.to_lower()]["isCleared"] and postStageText != "":
		%Label3D.text = postStageText
	
	## if related stage is not cleared
	else:
		%Label3D.text = preStageText



func _on_area_3d_body_entered(body: Node3D) -> void:
	if "Player" in body.get_groups():
		%TextAnimationPlayer.play("pop_up")

func _on_area_3d_body_exited(body: Node3D) -> void:
	if "Player" in body.get_groups(): # Replace with function body.
		%TextAnimationPlayer.play("pop_down")
