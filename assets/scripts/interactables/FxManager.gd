## FxManager is a script for the FxComponent.
## Its main function is to recursively handle emission of particles, as well as
## sounds. it does a bit of the same stuff as Interactable.gd, except that the
## point of FxManager.gd is to play a specific effect on every instance.
##
##
## ── FxComponent
##    └── AudioSteamPlayer3D
##        └── Audio
class_name FxManager extends Interactable

#The particleEffect you want to have played. This has to be a .tscn file
@export var particleEffect	: PackedScene # TODO: add some sort of default particle effect.

# the sound we will apply to our AudioStreamPlayer3D
@export var audioStream		: AudioStream

var audioPlayer	: AudioStreamPlayer3D  # chosen AudioStreamPlayer can always be changed later. Im not entirely sure how


func _ready() -> void:
	# generally speaking, you shouldnt touch the component scene itself, like ever.
	audioPlayer = get_child(0)

func on_interact():
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
