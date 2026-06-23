class_name Breakable extends Interactable

@export var breakEffect: PackedScene

@export_range(1,5,1) var HP: int

func on_interact():
	print("breakable object got interacted")
	HP -= 1

	if(HP <= 0):
		var ParticleInstance: CPUParticles3D = breakEffect.instantiate()
		ParticleInstance.global_position = parent.global_position
		ParticleInstance.one_shot = true # particles should always be destroyed after theyre done

		ParticleInstance.finished.connect(ParticleInstance.queue_free)
		get_parent().add_child(ParticleInstance)

		parent.queue_free()
