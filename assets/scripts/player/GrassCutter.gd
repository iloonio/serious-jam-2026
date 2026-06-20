extends CharacterBody3D

const SPEED = 5.0
const JUMP_VELOCITY = 4.5

var grassManager: GrassManager

@export var cutRadius: float = 1.0

var cutGrass: Array = []

func _ready() -> void:
	grassManager = get_tree().get_first_node_in_group("GrassManager")
	if not grassManager:
		push_error("GrassManager node not found in ", self)



func _physics_process(delta: float) -> void:
	cut_grass_in_radius()
	
	template_movement(delta)



func cut_grass_in_radius():
	var cellPos = get_current_cellpos()
	
	# calculate which cells you reach given the cutRadius
	var cellRange = ceil(cutRadius / grassManager.cell_size.x)
	
	
	# loop through grid around player
	for x in range(-cellRange, cellRange + 1):
		for z in range(-cellRange, cellRange + 1):
			var targetCell = cellPos + Vector3i(x, 0, z) 
			
			
			if grassManager.grassDic.has(targetCell) and targetCell not in cutGrass:
				var instanceID = grassManager.grassDic[targetCell]
				
				# get transform local to grassGridMap to find world position
				var grassTransform = grassManager.multimeshInstance.multimesh.get_instance_transform(instanceID)
				var grassWorldPos = grassTransform.origin
				#print("GrassTransform: ", grassTransform)
				#print("GrassWorldPos: ", grassWorldPos)
				
				# circular distance check
				if global_position.distance_to(grassWorldPos) <= cellRange:
					cutGrass.append(targetCell)
					#print("Cut grass: ", cutGrass)
					cut_grass_tile(targetCell, instanceID, grassWorldPos)



func cut_grass_tile(cell, index, worldPos):
	# pass color value to shader, which "cuts" the grass if the x value is 1.0
	grassManager.multimeshInstance.multimesh.set_instance_custom_data(index, Color(1.0, 0.0, 0.0, 0.0) )
	
	# remove grass from dictionary 
	grassManager.grassDic.erase(cell)
	
	# spawn_drop(worldPos)


func get_current_cellpos() -> Vector3i:
	var cellPos = Vector3i(
		floor(global_position.x / grassManager.cell_size.x),
		floor(global_position.y / grassManager.cell_size.y),
		floor(global_position.z / grassManager.cell_size.z)
	)
	return cellPos






func template_movement(delta) -> void:
	
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var input_dir := Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	var direction := (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)

	move_and_slide()
