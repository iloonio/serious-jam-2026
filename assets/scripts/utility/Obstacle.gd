class_name Obstacle extends Node3D

@export var isBreakable: bool = false

func _ready() -> void:
	var breakableNode = find_children("*", "BreakableObstacle", true, false)
	if breakableNode != null:
		for i in breakableNode:
			i.breakSelf.connect(break_self)
			break
	
	

func break_self():
	queue_free()
