extends Node3D
## obstacleCollider.gd is a generic class that requires its parent to be area3D.
## It fetches overlapping bodies in its parent, checks if they have the neccesary
## class, and then it runs its on_collision function, which lets the collided object
## manage its own state.

## the script with logic for handling the breakableObstacle.
@export var colliderClass: Script

@export_dir var colliderClassDirectory: String

var hitArea: Area3D
var colliderClassName: String

func _ready() -> void:
	colliderClassName = colliderClass.get_class()
	hitArea = get_parent()
	assert(hitArea is Area3D, "hitArea has incorrect typing")

func _physics_process(_delta: float) -> void:
	if hitArea.get_overlapping_bodies().size() < 1:
		return

	for col in hitArea.get_overlapping_bodies():
		if col.get_script().get_property_list()["class_name"] == colliderClassName:
			col.call("on_collision")
