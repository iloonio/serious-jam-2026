extends Node

var currentScore: int = 0

signal updateScore(score: int)
signal updateTimeLabel(secs: String, mins: String)

signal stageClear(totScore: int, score: int, timeBonus: int, rank: String)

var trackPlayerStats: bool = false

var levelStats: Dictionary = {
	"level1": {"isCleared": false, "topScore": 0, "topRank": "-"},
	"level2": {"isCleared": false, "topScore": 0, "topRank": "-"},
	"level3": {"isCleared": false, "topScore": 0, "topRank": "-"},
	"level4": {"isCleared": false, "topScore": 0, "topRank": "-"},
	"level5": {"isCleared": false, "topScore": 0, "topRank": "-"}
}


var startTime: float = 0




func _ready() -> void:
	enter_stage() # maybe not have this when we get a HUB



func _process(delta: float) -> void:
	if !trackPlayerStats:
		return
	
	@warning_ignore("integer_division")
	var mins = int(get_elapsed_time()/ 60) 
	mins = format_time_nums(mins)
	
	var secs = (get_elapsed_time() % 60) 
	secs = format_time_nums(secs)
	
	updateTimeLabel.emit(secs, mins)



func format_time_nums(num) -> String:
	if num < 10:
		num = "0" + str(num)

	return str(num)


## Returns elapsed time in seconds
func get_elapsed_time() -> int:
	var elapsedSeconds = (Time.get_ticks_msec() - startTime) / 1000.0
	return int(elapsedSeconds)


#isn't called anywhere yet
func enter_stage():
	currentScore = 0
	startTime = Time.get_ticks_msec()
	trackPlayerStats = true
	#currentTime = 0


func add_score(score: int):
	currentScore += score
	if trackPlayerStats:
		updateScore.emit(currentScore)


	## emit score to display in the end
func clear_stage(clearedStage: String = "level1"):

	@warning_ignore("integer_division")
	var timeBonus = int(30000 / get_elapsed_time())

	var finalScore = currentScore + timeBonus
	var rank = calculate_rank(clearedStage, finalScore)
	
	
	trackPlayerStats = false
	stageClear.emit(finalScore, currentScore, timeBonus, rank)
	
	
	## save data about the level run
	levelStats[clearedStage]["isCleared"] = true
	
	if currentScore > levelStats[clearedStage]["topScore"]:
		
		levelStats[clearedStage]["topScore"] = currentScore
		levelStats[clearedStage]["topRank"] = rank




func calculate_rank(_clearedStage: String = "level1", score : int = 0) -> String:
	## clearedStage could be used to check specific score requirements
	
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
