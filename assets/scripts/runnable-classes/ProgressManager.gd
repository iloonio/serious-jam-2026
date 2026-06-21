class_name ProgressManager extends RunnableScene

var grassManager : GrassManager

var grassTotal: int
var grassLeft: int

var startTime: float

var levelCleared: bool = false

var playerScore: int = 0:
	set(newScore):
		playerScore = newScore  
		_on_score_changed(playerScore) 


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
	@warning_ignore("integer_division")
	
	if levelCleared:
		return
	
	var mins = int(get_elapsed_time() / 60)
	mins = format_time_nums(mins)
	
	var secs = get_elapsed_time() % 60
	secs = format_time_nums(secs)
	
	
	%TimeLabel.text = "TIME: %s:%s" % [mins, secs]
	
func format_time_nums(num) -> String:
	if num < 10:
		num = "0" + str(num)

	return str(num)


func _physics_process(delta: float) -> void:
	if Input.is_action_just_pressed("Restart Level"):
		SceneManager.reload_scene()



func update_progress(newGrassAmount) -> void:
	grassLeft = newGrassAmount
	
	%GrassProgressLabel.text = "Grass left: " + str(grassLeft) + "/" + str(grassTotal)
	
	if grassLeft <= 0: 
		level_clear()


func level_clear() -> void:
	levelCleared = true
	
	%GrassProgressLabel.text = "YOU WON, PRESS [R] TO RETRY"
	
	var timeBonus = int(30000 / get_elapsed_time()) # 10 sec = 3000 points, 50 sec = 600 points
	
	var totScore: int = playerScore + timeBonus
	
	var rank: String = calculate_rank(totScore)
	
	%ScoreLabel.text = "Total Score: %d [Score: (%d) + Time Bonus: (%d)], <RANK: %s>" % [totScore, playerScore, timeBonus, rank] 
	


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


func _on_score_changed(score: int) -> void:
	if levelCleared:
		return

	%ScoreLabel.text = "Score: %d" % score


func _on_grass_grid_map_add_score(score: int) -> void:
	playerScore += score
