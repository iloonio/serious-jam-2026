extends RigidBody3D

#region Exports
@export_group("Angular Velocity")
## maxTorque caps the amount of force that will be applied around the y axis
## when the player rotates their character. The max value might not neccesarily
## be reached, but its there nonetheless.
@export_range(0.5, 24, 0.1) var maxTorque

## torqueAcceleration controls how fast player rotation speeds up towards maxTorque.
## it grows linearly but impacts rotations/sec exponentially!
@export_range(0, 4, 0.01) var torqueAcceleration

## torqueSlowDown controls how quickly torqueFactor is reduced when no direction
## key is pushed down.
@export_range(0.01, 1, 0.01) var torqueSlowDown

## Determines how much of a force is applied to the player in dirVec's direction while
## the player is turning with A or D
@export_range(0.5, 10, 0.1) var turnSpeed


@export_group("Linear Velocity")
## maxImpulse caps the length of the vector that is fed into the force Applier.
@export_range(1, 128, 1) var maxImpulse
@export_range(1,16, 0.1) var minLinearVelocity
## the limit of how high impulseFactor can be incremented before
@export_range(1, 64, 1) var maxChargeUpImpulse
@export_range(1, 64, 1) var minChargeUpImpulse

##how quickly we charge up, which is done by lerping. chargeUpRate is the weight
## so higher value = faster charge up.
@export_range(0.1, 5, 0.05) var ChargeCooldown = 0.5
@export_range(0.001, 0.5, 0.001) var ChargeUpRate
@export_range(0.4, 1, 0.01) var perfectChargeMinThreshold
@export_range(0.4, 1, 0.01) var perfectChargeMaxThreshold

@export_range(0, 1, 0.01) var bounceStrength
@export_range(1, 20, 0.5) var spinningForwardForceFactor: float

@export_group("Debugging")
## mesh to some sort of shape that can be used a direction indicator.
@export var directionGizmo: Node3D
## when enabled, various print statements will go off. you can disable specific print logs with other exports
@export var enableDebugPrints: bool = false
@export var enableChargeGaugePrints: bool = false
@export var enableDirVecPrints: bool = false
#endregion
#region Variables
var torqueFactor: float = 0 #incremented while turning, decremented when not.
var velocityFactor: float = 0 #depends on chargeGauge
var chargeGauge: float = 0 #incremented while charging
var isCharging: bool = false
var canBounce: bool = true
var chargeCooldownRemainder: float = 0

## DirVec is the direction of our movement.
## DirVec is reduced overtime by being lerped towards the unnit vection pointing forward
@onready var dirVec: Vector3 = Vector3(0,0,0)

enum dir {
	LEFT = 1,
	RIGHT = -1,
}
#endregion
#region Signals
signal isSpinning(flag: bool, speed: float)
signal velocity(currentVelocity: float)
signal charge(currentCharge: float, minThreshold: float, maxThreshold: float)
signal chargeRelease(isChargePerfect: bool, onCooldown: bool)
#endregion

var bertilMaterial = load("res://assets/visuals/materials/bertil.tres")


func _input(event: InputEvent) -> void:
	if GameState.blockInput:
		bertilMaterial.albedo_color = Color.WHITE
		return
	
	
	
	if(event.is_action_pressed("charge")):
		#if(chargeCooldownRemainder > 0):
		#	return
		torqueFactor = 0
		isCharging = true
		chargeGauge = 0
		print("PRESS")
		


			
		
		
	if(event.is_action_released("charge")):
		print("RELEASE")
		bertilMaterial.albedo_color = Color.WHITE
		isCharging = false
		
		if(chargeCooldownRemainder > 0):
			chargeRelease.emit(false, true)
			return
		if(perfectChargeMinThreshold <= chargeGauge and chargeGauge <= perfectChargeMaxThreshold):
			velocityFactor = maxImpulse
			chargeRelease.emit(true, false)
			perfect_dash_score()
		else:
			print("RETURN")
			velocityFactor += maxChargeUpImpulse*clampf(chargeGauge, 0.1, 1)
			chargeRelease.emit(false, false)
			


		calculateDirVec()
		apply_impulse(dirVec*max(velocityFactor, minChargeUpImpulse))
		chargeCooldownRemainder = ChargeCooldown


func perfect_dash_score():
	
	if get_parent().get_parent() is ProgressManager:
		if get_parent().get_parent().isClearableLevel == false:
			return
	
	
	var scoreLabel: PackedScene = load("res://assets/prefabs/ScoreLabel.tscn")
	var scoreLabelInstance: Label3D = scoreLabel.instantiate()
	
	GameState.add_score(50)
	scoreLabelInstance.text = "+" + str(50)
	Vector3(randf_range(-150, 150), randf_range(-150, 150), randf_range(-150, 150))
	get_tree().get_first_node_in_group("Player").add_child(scoreLabelInstance)




func _process(delta: float) -> void:
	## charging is handled in a seperate process
	if isCharging:
		
			## Charge color
		if(perfectChargeMinThreshold <= chargeGauge and chargeGauge <= perfectChargeMaxThreshold):
			bertilMaterial.albedo_color = Color(1.949, 1.949, 1.949, 1.0)
		else:
			bertilMaterial.albedo_color = Color.WHITE
		
		chargeGauge += delta*60*ChargeUpRate
		charge.emit(chargeGauge, perfectChargeMinThreshold, perfectChargeMaxThreshold)
		if(enableDebugPrints and enableChargeGaugePrints):
			print("chargeGauge: ",chargeGauge)


func _physics_process(delta: float) -> void:
	## 1. handle rotation inputs, -maxTorqueFactor, maxTorqueFactor, -1, 1),0,0) + VectrVec*(velocityFactor*spinningForwardForceFactor)or3(-transform.basis.z)).normalized()

	if(Input.is_action_pressed("left")):
		turnPlayer(dir.LEFT)
	elif(Input.is_action_pressed("right")):
		turnPlayer(dir.RIGHT)

	## 2. in the case we arent rotating, torque should be reduced back to zero.
	elif!(Input.is_action_pressed("left") or Input.is_action_pressed("right")):
		torqueFactor = lerpf(torqueFactor, 0, torqueSlowDown)

	## 3. apply impulse based on direction vector (dirVec)
	calculateDirVec()

	if(velocityFactor > 1):
		if(enableDebugPrints and enableDirVecPrints):
			print("current dirVec: ",dirVec)


		apply_force(dirVec*(velocityFactor*spinningForwardForceFactor))
		isSpinning.emit(true, remap(velocityFactor, 0, maxImpulse, 0.5, 4))

	else:
		isSpinning.emit(false, 0.5)


	## 4. reduce velocityFactor gently.delta
	## if we are charging, reduce to 0
	if(isCharging) and !(chargeCooldownRemainder > 0):
		velocityFactor = lerpf(velocityFactor, 0, 0.75)
	else:
		velocityFactor -= delta  #idk what to do here, but i dont want torque to slowdown so much lol
	chargeCooldownRemainder -= delta
	

func turnPlayer(direction: int):

	if torqueFactor < 5:
		torqueFactor += torqueAcceleration/10
	apply_torque((Vector3(0, torqueFactor*direction, 0)))
	# apply_force(dirVec)


func calculateDirVec() -> void:
	dirVec = (Vector3(remap(torqueFactor, -maxTorque, maxTorque, -1, 1),0,0) + Vector3(-transform.basis.z)).normalized()

	if directionGizmo.is_visible_in_tree():
		var target_rotation = Quaternion(Vector3.FORWARD, dirVec)
		directionGizmo.global_transform.basis = Basis(target_rotation)

var hasColliderNormals: bool = false


func _integrate_forces(state: PhysicsDirectBodyState3D) -> void:
	var linLength: float = state.linear_velocity.length() or 0

	if linLength > maxImpulse:
		state.linear_velocity = state.linear_velocity.normalized() * maxImpulse


	if state.angular_velocity.length() > maxTorque:
		state.angular_velocity = state.angular_velocity.normalized() * maxTorque


	velocity.emit(remap(state.linear_velocity.length(),0, maxImpulse, 0, 1))



func _on_wall_bounce_shape_cast_collision_normals(colliderNormals: Array[Vector3]) -> void:
	# here, we want to reflect the dirVec
	# to simplify things a bit, lets add together all of the normals and normalize them
	# thereafter, calculate reflection and set dirVec to point in that direction.

	var sumNormal = Vector3.ZERO

	#print("on_shape_cast_3d called")

	# sum up all normals
	for n in colliderNormals:
		sumNormal += n

	# normalize summation to make it a proper normal vector
	sumNormal = sumNormal.normalized()

	#print(colliderNormals)
	dirVec = dirVec - (2*dirVec.dot(sumNormal)*sumNormal)

	# linear_velocity = Vector3.ZERO
	apply_impulse(dirVec*bounceStrength*max(velocityFactor, minLinearVelocity))

	velocityFactor = lerp(velocityFactor, 0.0, 0.2)
