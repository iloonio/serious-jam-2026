extends Node3D


@export_category("Positioning Settings")
@export var cameraHeightOffset: float = 10.0
@export var cameraRotationX: float = -55.0
@export var cameraPosOffsetZ: float = 6.0


@export_category("Follow Settings")
## How fast the camera catches up to the Player
@export var followSpeed: float = 0.2 

@export_category("Margins")
## The horizontal margin for the camera deadzone
@export var marginHorizontal: float = 5.0 
## The verical margin for the camera deadzone
@export var marginVertical: float = 4.0



var player: RigidBody3D

var targetPos

var constantOffset: Vector3 

@onready var camera = %Camera3D


var lastPos: Vector3

var futurePos


func _ready() -> void:
	player = get_tree().get_first_node_in_group("Player")
	if not player:
		return
	
	global_position = player.global_position
	lastPos = global_position
	futurePos = global_position
	


func _physics_process(delta: float) -> void:
	if not player:
		return
	
	
	var targetPos: Vector3 = player.global_position + Vector3(0, cameraHeightOffset, 0)
	
	
	## OBS!! MOVE TO _ready() once done testing for values
	camera.rotation.x = deg_to_rad(cameraRotationX) # deg_to_rad
	%SpringArm3D.spring_length = cameraPosOffsetZ
	global_position.y = cameraHeightOffset


	var hOffset = global_position.x - targetPos.x
	var vOffset = global_position.z - targetPos.z


	# here player is outside of margin x
	if abs(hOffset) > marginHorizontal:
		if hOffset > 0:
			global_position.x = lerp(global_position.x, marginHorizontal + targetPos.x, followSpeed)
		else:
			global_position.x = lerp(global_position.x, marginHorizontal * -1 + targetPos.x, followSpeed)
		
		# store a position slightly ahead of player, so if you turn/bounce suddenly, camera has somewhere to lerp to
		futurePos.x = global_position.x + (global_position.x - lastPos.x) * player.linear_velocity.x 
		
		
	# here player is inside margin of x
	else: 
		global_position.x = lerp(global_position.x, futurePos.x, followSpeed)


	# here player is outside of margin z
	if abs(vOffset) > marginVertical:
		if vOffset > 0:
			global_position.z = lerp(global_position.z, marginVertical + targetPos.z, followSpeed)
		else:
			global_position.z = lerp(global_position.z, marginVertical * -1 + targetPos.z, followSpeed)
		
		# store a position slightly ahead of player, so if you turn/bounce suddenly, camera has somewhere to lerp to
		futurePos.z = global_position.z + (global_position.z - lastPos.z) * player.linear_velocity.z

	else: # here player is inside margin of z
		global_position.z = lerp(global_position.z, futurePos.z, followSpeed)
	
	
	
	lastPos = global_position
	
