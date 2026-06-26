extends Node3D


var spinBandpassFilter: AudioEffectBandPassFilter

@export_category("Spin Bandpass Filter")
@export var spinEffectIndex: int = 0

@export var spinMinFreq: float = 1000.0
@export var spinMaxFreq: float = 4500.0

@export var spinAnimationPlayer: AnimationPlayer



var chargePitchShift: AudioEffectPitchShift

@export_category("Charge Pulse Pitch Shift")
@export var chargeEffectIndex: int = 0

@export var minPitch: float = 1.0
@export var maxPitch: float = 2.0



var passedMinThreshold: bool = false
var passedMaxThreshold: bool = false




func _ready() -> void:
	
	# fetch audiobus effect for spin
	var spinEffect = AudioServer.get_bus_effect(AudioServer.get_bus_index("PlayerSpin"), spinEffectIndex)

	if spinEffect is AudioEffectBandPassFilter:
		spinBandpassFilter = spinEffect
	else:
		push_error("Effect at index  %d is not a BandPassFilter" % spinEffectIndex)


	# fetch audiobus effect for charge pulse
	var chargeEffect = AudioServer.get_bus_effect(AudioServer.get_bus_index("PlayerCharge"), chargeEffectIndex)

	if chargeEffect is AudioEffectPitchShift:
		chargePitchShift = chargeEffect
	else:
		push_error("Effect at index  %d is not a BandPassFilter" % chargeEffectIndex)




func _process(delta: float) -> void:
	#spinSFX()
	spinSFX()




func spinSFX() -> void:
	if not spinBandpassFilter:
			return

	
	var animPos: float = spinAnimationPlayer.current_animation_position
	var animLength: float = spinAnimationPlayer.get_animation("Spinning").length

	# from 0 to 1
	var animProgress = animPos/animLength

	# maps value as 0 -> 0-5 -> 1 -> 0-5 -> 0 
	var normalizedProgress = abs(1 - animProgress * 2)

	# map the animation progress to the cutoff frequency
	var targetCutoff = lerp(spinMinFreq, spinMaxFreq, normalizedProgress)
	spinBandpassFilter.cutoff_hz = targetCutoff





func spinSFXold() -> void:
	if not spinBandpassFilter:
			return

	# get player rotation
	var playerRot = rotation.y
	
	# normalize so rotation loops between from 0 to 1
	var normalizedRot = abs(sin(playerRot))

	# map the rotation to the cutoff frequency
	var targetCutoff = lerp(spinMinFreq, spinMaxFreq, normalizedRot)
	spinBandpassFilter.cutoff_hz = targetCutoff
	
	







func _on_player_charge(currentCharge: float, minThreshold: float, maxThreshold: float) -> void:
	
	## checks for when exiting and entering perfect charge threshold
	
	if currentCharge >= maxThreshold:
		if !passedMaxThreshold:
			%OvershootSFX.play()
			passedMaxThreshold = true
	
	elif currentCharge >= minThreshold:
		if !passedMinThreshold:
			%InThresholdSFX.play()
			%ChargePulseSFX.stop()
			passedMinThreshold = true
	
	## charge pulse
	elif !%ChargePulseSFX.playing:
		%ChargePulseSFX.play()
	chargePitchShift.pitch_scale = 1 + currentCharge*10




func _on_player_charge_release(isChargePerfect: bool, onCooldown: bool) -> void:
	
	if !onCooldown:
		match isChargePerfect:
			true: %BigReleaseSFX.play()
			false: %SmallReleaseSFX.play()
	
	
	## reset variables for next charge
	%ChargePulseSFX.stop()
	chargePitchShift.pitch_scale = 1
	
	passedMinThreshold = false
	passedMaxThreshold = false
	
	
	


func _on_player_is_spinning(flag: bool, speed: float) -> void:
	var isSpinning = flag

	if isSpinning:
		if %SpinSFX.playing == false:
			%SpinSFX.play()
	else:
		if %SpinSFX.playing == true:
			%SpinSFX.stop()



func _on_wall_bounce_shape_cast_collision_normals(colliderNormals: Array[Vector3]) -> void:
	%BounceSFX.play()
	
	
