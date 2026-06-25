extends Control

var progressManager

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	progressManager = get_tree().get_first_node_in_group("ProgressManager")
	if !progressManager:
		push_warning("Could not ProgressManager in ", self, ". Please Ensure that the node with ProgressManager.gd is also a member of the global group ProgressManager.")

	progressManager.updateGrassCount.connect(update_grass_count_label)
	#progressManager.updateScore.connect(update_score_label)
	#progressManager.updateTime.connect(update_time_label)
	#progressManager.updateRanking.connect(update_ranking_text)
	
	GameState.updateTimeLabel.connect(update_time_label)
	GameState.updateScore.connect(update_score_label)
	GameState.stageClear.connect(update_ranking_text)



func update_grass_count_label(grassLeft, grassTotal):
	%GrassCountLabel.text = "Grass left: " + str(grassLeft) + "/" + str(grassTotal)
	
	if grassLeft <= 0:
		%GrassCountLabel.text += " YOU WON, PRESS [R] TO RETRY"
	

func update_score_label(score):
	%ScoreLabel.text = "Score: %d" % score



func update_time_label(secs, mins):
	%TimeLabel.text = "TIME: %s:%s" % [mins, secs]
	

## runs when a level is cleared
func update_ranking_text(totScore, playerScore, timeBonus, rank):
	%ScoreLabel.text = "Total Score: %d [Score: (%d) + Time Bonus: (%d)], RANK: %s" % [totScore, playerScore, timeBonus, rank]
