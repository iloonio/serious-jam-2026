extends AnimationPlayer

var rng = RandomNumberGenerator.new()

func _ready() -> void:
	self.play("standingIdle", 1)

func _on_player_is_spinning(flag: bool, speed: float) -> void:
	if flag:
		self.play("Spinning", -1, speed)
	else:
		playIdleAnimation()

func playIdleAnimation() -> void:
	var random_value = rng.randi_range(0,10)

	if(random_value >= 8):
		self.play("standingIdle", -1, 0.5)
	else:
		self.play("standingIdleVariant", 1)
