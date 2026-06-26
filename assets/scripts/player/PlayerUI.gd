extends Control

var progressManager

var canContinue: bool = false


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
	%GrassCountLabel.text = str(grassLeft) + "/" + str(grassTotal)

	if grassLeft <= 0:
		%GrassCountLabel.text


func update_score_label(score):
	%ScoreLabel.text = "Score: %d" % score



func update_time_label(secs, mins):
	%TimeLabel.text = "TIME: %s:%s" % [mins, secs]


## runs when a level is cleared
func update_ranking_text(totScore, playerScore, timeBonus, rank):
	
	
	%RankLabel.text = "YOUR RANK"
	%RankResult.text = rank
	%FinalScoreLabel.text = "SCORE: %d" % playerScore
	%ScoreBreakdownLabel.text = "TIME BONUS: %d" % timeBonus

	%AnimationPlayer.play("clear_stage")


func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	if anim_name == "clear_stage":
		%AnimationPlayer.play("continue")
		canContinue = true


func _input(event: InputEvent) -> void:
	if !canContinue:
		return
	
	if event.is_action_pressed("charge"):
		SceneManager.load_scene("res://assets/play-scenes/levels/LevelLobby.tscn")
