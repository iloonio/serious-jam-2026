class_name ProgressManager extends RunnableScene

var grassManager : GrassManager

var grassTotal: int
var grassLeft: int

var startTime: float


signal updateGrassCount
signal updateRanking

var canReturn: bool = false

@export var isClearableLevel: bool = true



## Returns elapsed time in seconds
func get_elapsed_time() -> int:
	var elapsedSeconds = (Time.get_ticks_msec() - startTime) / 1000.0
	return int(elapsedSeconds)



func _ready() -> void:
	super._ready()
	
	grassManager = get_tree().get_first_node_in_group("GrassManager")
	grassManager.updatedGrassDic.connect(update_progress)
	
	grassTotal = grassManager.grassDic.size()
	
	update_progress(grassTotal)
	
	startTime = Time.get_ticks_msec()
	
	warm_up_particles()
	
	GameState.enter_stage()





func format_time_nums(num) -> String:
	if num < 10:
		num = "0" + str(num)

	return str(num)




func update_progress(newGrassAmount) -> void:
	if !isClearableLevel:
		return
	
	grassLeft = newGrassAmount
	
	updateGrassCount.emit(grassLeft, grassTotal)
	
	if grassLeft <= 0: 
		GameState.clear_stage()
		canReturn = true



func _on_grass_grid_map_add_score(score: int) -> void:
	GameState.add_score(score)




func warm_up_particles():
	var particle = load("res://assets/prefabs/particle-fx/ParticleWarmup.tscn")
	var particleInstance = particle.instantiate()
	particleInstance.position = Vector3(0, -100, 0)
	add_child(particleInstance)
		

	
