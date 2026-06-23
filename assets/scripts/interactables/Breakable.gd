class_name Breakable extends Interactable

@export var breakEffect: PackedScene

@export_range(1,5,1) var HP: int

func on_interact():
	print("breakable object got interacted")
	HP -= 1

	if(HP <= 0):
		var particleInstance: CPUParticles3D = breakEffect.instantiate()
		particleInstance.position = parent.position + Vector3(0,0,0)
		particleInstance.finished.connect(particleInstance.queue_free)

		# propagate the call to all children in case of layered particles
		particleInstance.propagate_call("set", ["one_shot", true])
		particleInstance.propagate_call("set", ["emitting", true])

		get_parent().get_parent().add_child(particleInstance)



		# await get_tree().create_timer(0.5).timeout
		parent.queue_free()

	# on_interact() shouldnt be callable on its instance for some duration.
	# TODO: turn the timeout time into an exported value inside of obstacleCollider.gd
