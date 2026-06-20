extends RigidBody3D

@export_category("Instances")
@export var directionGizmo: Node3D


@export_category("Torque/Rotation Settings")
## maxTorque caps the amount of force that will be applied around the y axis
## when the player rotates their character. The max value might not neccesarily
## be reached, but its there nonetheless.
@export_range(0.01, 1, 0.01) var maxTorque

## torqueAcceleration controls how fast player rotation speeds up towards maxTorque.
## it grows linearly but impacts rotations/sec exponentially!
@export_range(0, 4, 0.01) var torqueAcceleration

## torqueSlowDown controls how quickly torqueFactor is reduced when no direction
## key is pushed down.
@export_range(0.01, 1, 0.01) var torqueSlowDown


@export_category("Impulse/Speed Settings")
## maxImpulse caps the length of the vector that is fed into the force Applier.
@export_range(1, 128, 1) var maxImpulse

## the limit of how high impulseFactor can be incremented before
@export_range(1, 64, 1) var maxChargeUpImpulse

@export_range(1, 64, 1) var minChargeUpImpulse

##how quickly we charge up, which is done by lerping. chargeUpRate is the weight
## so higher value = faster charge up.
@export_range(0.001, 0.5, 0.001) var ChargeUpRate

@export_range(0.4, 1, 0.01) var perfectChargeMinThreshold

@export_range(0.4, 1, 0.01) var perfectChargeMaxThreshold


var torqueFactor: float = 0 #incremented while turning, decremented when not.
var velocityFactor: float = 0 #depends on chargeGauge
var chargeGauge: float = 0 #incremented while charging
var isCharging: bool = false

## DirVec is the direction of our movement.
## DirVec is reduced overtime by being lerped towards the unit vection pointing forward
@onready var dirVec: Vector3 = Vector3(0,0,0)

enum dir {
	LEFT = 1,
	RIGHT = -1,
}

func _input(event: InputEvent) -> void:
	if(event.is_action_pressed("charge")):
		isCharging = true
		chargeGauge = 0
	if(event.is_action_released("charge")):
		isCharging = false
		if(perfectChargeMinThreshold <= chargeGauge and chargeGauge <= perfectChargeMaxThreshold):
			velocityFactor = maxImpulse
		else:
			velocityFactor += maxChargeUpImpulse*clampf(chargeGauge, 0, 1)

		calculateDirVec()
		apply_impulse(dirVec*max(velocityFactor, minChargeUpImpulse))


func _process(delta: float) -> void:
	## charging is handled in a seperate process
	if isCharging:
		chargeGauge += delta*60*ChargeUpRate
		print("chargeGauge: ",chargeGauge)


func _physics_process(delta: float) -> void:
	## 1. handle rotation inputs, -maxTorqueFactor, maxTorqueFactor, -1, 1),0,0) + Vector3(-transform.basis.z)).normalized()

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
		print("current dirVec: ",dirVec)
		apply_force(dirVec*velocityFactor)


	## 4. reduce velocityFactor gently.
	## if we are charging, reduce to 0
	if(isCharging):
		velocityFactor = lerpf(velocityFactor, 0, 0.75)
	else:
		velocityFactor -= delta #idk what to do here, but i dont want torque to slowdown so much lol

func turnPlayer(direction: int):
	torqueFactor += torqueAcceleration/10
	apply_torque_impulse((Vector3(0, torqueFactor*direction, 0)))

func calculateDirVec() -> void:
	dirVec = (Vector3(remap(torqueFactor, -maxTorque, maxTorque, -1, 1),0,0) + Vector3(-transform.basis.z)).normalized()

	if directionGizmo.is_visible_in_tree():
		var target_rotation = Quaternion(Vector3.FORWARD, dirVec)
		directionGizmo.global_transform.basis = Basis(target_rotation)
