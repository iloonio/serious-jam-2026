@tool
## FxManager is a script for the FxComponent.
## Its main function is to recursively handle emission of particles, as well as
## sounds. it does a bit of the same stuff as Interactable.gd, except that the
## point of FxManager.gd is to play a specific effect on every instance.
##
## ── FxComponent
##    └── AudioSteamPlayer3D
##        └── Audio
class_name FxManager extends Interactable

#The particleEffect you want to have played. This has to be a .tscn file
@export var particleEffect : PackedScene # TODO: add some sort of default particle effect.

# chosen AudioStreamPlayer can always be changed later. This is an export entirely for my own convenience
@export var audioPlayer	: AudioStreamPlayer3D

# the sound that will be played.
@export var audioStream	: AudioStream:
	get:
		return audioStream
	set(audio):
		if(audio != null):
			audioPlayer.stream = audio
			audioStream = audio

@export var animationPlayer: AnimationPlayer

@export_range(0, 1, 0.05) var cooldown: float = 0.2

var can_be_hit: bool = true



func on_interact():
	# 0. If we cannot be hit, return early
	if not can_be_hit:
		return

	can_be_hit = false
	## 1. instantiate particles, have them clean up automatically when they finish playing
	var particleInstance: CPUParticles3D = particleEffect.instantiate()
	particleInstance.position = parent.position
	particleInstance.finished.connect(particleInstance.queue_free)

	## 1.1. propagate the call to all children in case of layered particles
	particleInstance.propagate_call("set", ["one_shot", true])
	particleInstance.propagate_call("set", ["emitting", true])

	get_parent().get_parent().add_child(particleInstance)

	## 2. play audio resource
	audioPlayer.play(0)
	audioPlayer.finished.connect(audioPlayer.stop)
	
	## 3. play animation if an AnimationPlayer is added as export
	if animationPlayer:
		var animations = animationPlayer.get_animation_list()
		print(animations)
		animationPlayer.play(animations[0])
	
	# 4. wait for cooldown, then allow being hit again
	await get_tree().create_timer(cooldown).timeout
	can_be_hit = true
