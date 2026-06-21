extends Node3D

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
	
	check_breakable_collision()


func check_breakable_collision() -> void:
	pass
	#for col in get_slide_collision_count():
	#	var hitObject = get_slide_collision(col).get_collider()
	#	if hitObject is BreakableObstacle:
	#		hitObject.take_hit()
			
		

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
	grassManager.cut_grass_on_cell(cell, index, worldPos)
	# spawn_drop(worldPos)


func get_current_cellpos() -> Vector3i:
	var cellPos = Vector3i(
		floor(global_position.x / grassManager.cell_size.x),
		floor(global_position.y / grassManager.cell_size.y) - 1,
		floor(global_position.z / grassManager.cell_size.z)
	)
	return cellPos
