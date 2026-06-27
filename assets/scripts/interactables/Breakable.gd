class_name Breakable extends Interactable

@export var breakEffect: PackedScene

@export var breakAudioStream: AudioStreamPlayer 

@export_range(1,100,1) var HP: int

@export_range(0, 1, 0.05) var cooldown: float = 0.2

var can_be_hit: bool = true

signal onBreak()

func on_interact():
	if not can_be_hit:
		return
	# enter invincibility frames immediately to avoid concurrent hits
	can_be_hit = false
	HP -= 1


	if HP <= 0:
		onBreak.emit()
		
		if breakEffect != null:
			var particleInstance: CPUParticles3D = breakEffect.instantiate()

			particleInstance.position = parent.position
			particleInstance.finished.connect(particleInstance.queue_free)

			# propagate the call to all children in case of layered particles
			particleInstance.propagate_call("set", ["one_shot", true])
			particleInstance.propagate_call("set", ["emitting", true])
			
			if breakAudioStream != null:
				breakAudioStream.autoplay = true
				particleInstance.add_child(breakAudioStream.duplicate())
			
			get_parent().get_parent().add_child(particleInstance)
		

			
		
		
		parent.queue_free()
		return

	# wait for cooldown, then allow being hit again
	await get_tree().create_timer(cooldown).timeout
	can_be_hit = true
