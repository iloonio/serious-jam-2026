extends CPUParticles3D

## all fx that will be played when player is charging up (there is 2 of them)
## Group name:
	## ChargeUpVFX
var chargeUpVFX: Array = [Node3D]

## fx that plays on charge release. there should only be one but just in case
## more are added this is kept as an array
## Group name:
	## ChargeReleaseVFX
var chargeReleaseVFX: Array = [Node3D]

## all fx that play when a perfect charge is performed
## Group name:
	## PerfectChargeVFX
var perfectChargeVFX: Array = [Node3D]

func _ready() -> void:
	# get all the children
	chargeUpVFX = get_tree().get_nodes_in_group("ChargeUpVFX")

	chargeReleaseVFX = get_tree().get_nodes_in_group("ChargeReleaseVFX")

	perfectChargeVFX = get_tree().get_nodes_in_group("PerfectChargeVFX")

	# thats it!



# its important to note that chargeUpVFX are not set to OneShot, so they have to be manually turned off
# when the player releases charge
func _on_player_charge(currentCharge: float, minThreshold: float, maxThreshold: float) -> void:
	# we want to emit all VFX when the player charges.
	for vfx in chargeUpVFX:
		if vfx is CPUParticles3D:
			vfx.one_shot = false
			vfx.emitting = true
			# Scale emission rate based on charge progress
			# var chargeProgress = (currentCharge - minThreshold) / (maxThreshold - minThreshold)
			# vfx.amount_ratio = clamp(chargeProgress, 0.3, 1.0)


func _on_player_charge_release(isChargePerfect: bool, onCooldown: bool) -> void:
	# we want to set chargeUpVFX particles to be Oneshot when this is called
	# once these finish playing, they should be set back to not being oneshot.
	# we want to emit release VFX when the player releases charge.
	#
	print(isChargePerfect)


	

	if isChargePerfect:
		# we want to emit perfectChargeVFX in the case of a perfectCharge
		for vfx in perfectChargeVFX:
			if vfx is CPUParticles3D:
				vfx.restart()
				vfx.emitting = true

	for vfx in chargeReleaseVFX:
		if vfx is CPUParticles3D:
			vfx.restart()
			vfx.emitting = true

	# Set chargeUpVFX to OneShot mode so they finish naturally
	for vfx in chargeUpVFX:
		if vfx is CPUParticles3D:
			vfx.one_shot = true
			if onCooldown:
				vfx.emitting = false
				#vfx.restart()
			# Wait for this particle to finish, then reset OneShot mode
			# vfx.emitting = await vfx.finished.connect(func(): return false)
