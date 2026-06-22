class_name ProgressManager extends RunnableScene

var grassManager : GrassManager

var grassTotal: int
var grassLeft: int

var startTime: float

var levelCleared: bool = false

var playerScore: int = 0



signal updateGrassCount
signal updateScore
signal updateTime
signal updateRanking



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



func _process(delta: float) -> void:
	if levelCleared:
		return
	
	@warning_ignore("integer_division")
	var mins = int(get_elapsed_time() / 60)
	mins = format_time_nums(mins)
	
	var secs = get_elapsed_time() % 60
	secs = format_time_nums(secs)
	
	
	updateTime.emit(secs, mins)


func format_time_nums(num) -> String:
	if num < 10:
		num = "0" + str(num)

	return str(num)




func update_progress(newGrassAmount) -> void:
	grassLeft = newGrassAmount
	
	updateGrassCount.emit(grassLeft, grassTotal)
	
	if grassLeft <= 0: 
		level_clear()


func level_clear() -> void:
	levelCleared = true
	
	var timeBonus = int(30000 / get_elapsed_time()) # 10 sec = 3000 points, 50 sec = 600 points
	
	var totScore: int = playerScore + timeBonus
	
	var rank: String = calculate_rank(totScore)
	
	updateRanking.emit(totScore, playerScore, timeBonus, rank)
	


func calculate_rank(score : int) -> String:
	var rank: String = "E"
	
	if score >= 3000:
		rank = "S"
	elif score >= 2500:
		rank = "A"
	elif score >= 2000:
		rank = "B"
	elif score >= 1500:
		rank = "C"
	elif score >= 1000:
		rank = "D"
	
	return rank



func _on_grass_grid_map_add_score(score: int) -> void:
	playerScore += score

	if levelCleared:
		return

	updateScore.emit(playerScore)
