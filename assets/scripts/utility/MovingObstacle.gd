class_name MovingObstacle extends Obstacle

@export var isStatic: bool = false
@export var SPEED: float = 1.0
@export var cooldownTime: float = 1.0

var targetValue: float = 1.0

func _ready() -> void:
	super._ready()
	# adjust collision shape to mesh
	%CollisionShape3D.shape.size = %MeshInstance3D.mesh.size


func _physics_process(delta: float) -> void:
	# do nothing while on cooldown
	if %CooldownTimer.time_left != 0 or isStatic: 
		return
	
	# move towards target
	%PathFollow3D.progress_ratio = move_toward(%PathFollow3D.progress_ratio, targetValue, delta * SPEED / %Path3D.curve.get_baked_length())

	# check if target is reached
	if %PathFollow3D.progress_ratio == targetValue:
		print("TIMER START")
		%CooldownTimer.start(cooldownTime)
		
	
	

func _on_cooldown_timer_timeout() -> void:
	swap_target()
	

func swap_target() -> void:
	if targetValue == 1.0:
		targetValue = 0.0
	else:
		targetValue = 1.0
