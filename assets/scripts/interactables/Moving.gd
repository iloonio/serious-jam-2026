@tool
extends Path3D

## this script is supposed to be on a MovingObject.tcsn
## It is responsible for updating the pathFollow3D position,
## it is also responsible for adjusting the rigidBody3D when its updated!

## placeholder object to be instantiated when we dont have an instance
@export var PlaceholderObject: PackedScene = load("res://assets/prefabs/PerfectlyGenericCube.tscn")

## The object that will be moving along the Path3D
@export var movingObject: PackedScene:
	get:
		return movingObject
	set(scene):
		if(scene != null):
			get_child(0).get_child(0).queue_free()
			get_child(0).add_child(scene.instantiate())
			movingObject = scene


## the path follow 3D!
@export var pathFollow: PathFollow3D

@export_range(0.01, 1, 0.005) var progressIncrement: float = 0.05

@export var pingPong: bool = true

var signFactor: int = 1

func _ready() -> void:
	var obj = get_child(0).get_child(0)
	if obj is RigidBody3D:
		obj.freeze_mode = RigidBody3D.FREEZE_MODE_KINEMATIC
		obj.freeze = true

		# this ensures that when the movingObject enters the scene,
		# we get a unique instance of curve. its a nice quality of life.
		curve = curve.duplicate()




func _physics_process(_delta: float) -> void:
	if !pingPong: 
		pathFollow.progress_ratio = pathFollow.progress_ratio + progressIncrement*_delta
		
		if progressIncrement >= 1:
			progressIncrement = 0
		
		return
	
	pathFollow.progress_ratio = clampf(pathFollow.progress_ratio + progressIncrement*signFactor*_delta, 0, 1)

	if(pathFollow.progress_ratio >= 1):
		signFactor *= -1
	elif(pathFollow.progress_ratio <= 0):
		signFactor *= -1
