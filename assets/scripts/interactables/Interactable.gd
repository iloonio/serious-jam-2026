@abstract class_name Interactable extends Node

var parent: RigidBody3D

func _ready() -> void:
	parent = get_parent()
	assert(parent.get_class() == "RigidBody3D", "interactable component node must have a rigidbody3d parent")


@abstract func on_interact()
