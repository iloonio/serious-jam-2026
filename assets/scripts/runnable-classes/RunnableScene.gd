class_name RunnableScene extends Node


func _ready() -> void:
	if not is_inside_game():
		call_deferred("bootstrap_into_game")
	


	## Returns true if running the game via GameScene
func is_inside_game() -> bool: 
	return get_tree().get_first_node_in_group("GameScene") != null 
	


	## Runs when running this scene directly, so this scene becomes the child of GameScene
func bootstrap_into_game() -> void: 
	var gameScene = load("res://assets/play-scenes/GameScene/GameScene.tscn").instantiate()
	
	get_tree().root.add_child(gameScene)
	
	var currentSceneNode = gameScene.get_node("SubViewportContainer/SubViewport/CurrentScene")
	
	# place node as child of current_scene
	for child in currentSceneNode.get_children():
		child.queue_free() # to delete whatever is there to start with
	
	get_parent().call_deferred("remove_child", self)
	currentSceneNode.call_deferred("add_child", self)
	
