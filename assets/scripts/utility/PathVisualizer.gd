extends PathFollow3D

var signFactor: int = 1 #pingponging

@export_range(0.0, 0.5, 0.001) var deltaFactor: float

func _process(_delta: float) -> void:
	self.progress_ratio += signFactor * deltaFactor

	if(self.progress_ratio >= 1.0):
		signFactor *= -1
	elif(self.progress_ratio <= 0.0):
		signFactor *= -1
