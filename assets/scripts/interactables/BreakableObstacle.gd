class_name BreakableObstacle extends StaticBody3D

@export var HP: int = 1
signal breakSelf

func on_collision(damage: int = 1):
	HP -= damage

	if HP <= 0:
		breakSelf.emit()
