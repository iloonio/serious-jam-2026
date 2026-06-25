extends AnimationPlayer

var rng = RandomNumberGenerator.new()

var isIdle = false

func _ready() -> void:
	playIdleAnimation()

func _on_player_is_spinning(flag: bool, speed: float) -> void:
	if flag:
		self.play("Spinning", -1, speed)
	else:
		playIdleAnimation()

func playIdleAnimation() -> void:
	if(isIdle):
		return

	isIdle = true

	var random_value = rng.randi_range(0,10)

	if(random_value >= 6):
		self.play("standingIdle", -1, 0.5)
	else:
		self.play("standingIdleVariant", 1)

	await get_tree().create_timer(3).timeout
	isIdle = false
