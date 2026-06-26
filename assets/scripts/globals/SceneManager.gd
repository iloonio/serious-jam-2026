extends Node

var gameScene: Node

var currentSceneNode: Node3D

var sceneToLoad: String


func _ready() -> void:
	preload("res://assets/play-scenes/levels/Level1.tscn")
	preload("res://assets/play-scenes/levels/Level2.tscn")
	preload("res://assets/play-scenes/levels/Level3.tscn")



	## Starts process of transitioning to a specified scene of class RunnableScene
func load_scene(newScenePath: String):
	get_scene_refs()
	
	sceneToLoad = newScenePath
	
	gameScene.fade_out()



	## Starts process of reloading the current child of CurrentScene node in GameScene 
func reload_scene():
	get_scene_refs()
	
	for child in currentSceneNode.get_children():
		if child is RunnableScene:
			sceneToLoad = child.get_scene_file_path()
	
	gameScene.fade_out()



	## Occurs after load_scene() or reload_scene(), and handles the actual scene swapping
func transition_scene():
	var newSceneInstance = load(sceneToLoad).instantiate()
	
	clean_current_nodes()
	
	# to let nodes actually disappear completely
	await get_tree().process_frame 
	
	if newSceneInstance is RunnableScene:
		currentSceneNode.call_deferred("add_child", newSceneInstance)
		print(self, ": loading world") 
	else: 
		push_error(self, ": loading failed, newSceneInstance was not RunnableScene")
	
	gameScene.fade_in()



	## (Runs on every scene load for simplicity, but suboptimal)
func get_scene_refs():
	gameScene = get_tree().get_first_node_in_group("GameScene")
	
	currentSceneNode = gameScene.get_node("SubViewportContainer/SubViewport/CurrentScene")

	gameScene.hasFadedOut.connect(transition_scene)



	## Removes all children of "CurrentScene" node in GameScene
func clean_current_nodes():
	for child in currentSceneNode.get_children():
		child.queue_free() 
