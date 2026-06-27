class_name GrassManager extends GridMap

@export var grassMesh: Mesh
var grassID

# for scythe check in player (grass coordinate Vector3i(x,y,z) as keys)
var grassDic: Dictionary = {}

var multimeshInstance: MultiMeshInstance3D

var grassParticleFX: PackedScene = preload("res://assets/prefabs/particle-fx/GrassParticles.tscn")


signal updatedGrassDic
signal addScore(score: int)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	grassID = mesh_library.find_item_by_name("GrassFull")
	
	if not grassMesh:
		push_error("Grass mesh not found in ", self)
	
	convert_gridmap_to_multimesh()




func cut_grass_on_cell(cell, index, worldPos) -> void:
	# pass color value to shader, which "cuts" the grass if the x value is 1.0
	multimeshInstance.multimesh.set_instance_custom_data(index, Color(1.0, 0.0, 0.0, 0.0) )
	
	# remove grass from dictionary 
	grassDic.erase(cell)
	
	play_cut_sfx()
	
	spawn_grass_particles(worldPos + Vector3(0, 0.5, 0))
	
	updatedGrassDic.emit(grassDic.size())
	
	addScore.emit(2)


func convert_gridmap_to_multimesh() -> void:

	# get cells that match grass ID
	var grassCells: Array[Vector3i] = []
	for cell in get_used_cells():
		if get_cell_item(cell) == grassID:
			grassCells.append(cell)
			
	if grassCells.is_empty():
		return

	print(grassCells.size())


	# create MultiMeshInstance and its MultiMesh resource
	multimeshInstance = MultiMeshInstance3D.new()
	var newMultimesh := MultiMesh.new()
	
	newMultimesh.use_custom_data = true
	
	newMultimesh.transform_format = MultiMesh.TRANSFORM_3D
	newMultimesh.mesh = grassMesh
	newMultimesh.instance_count = grassCells.size()
	
	multimeshInstance.multimesh = newMultimesh
	
	#get_parent().add_child(multimeshInstance)
	add_child(multimeshInstance)




	# positions from GridMap to MultiMesh
	for i in range(grassCells.size()):
		var cell = grassCells[i]
		var scenePos = map_to_local(cell) 
		var cellBasis = get_cell_item_basis(cell)
		
		var trans = Transform3D(cellBasis, scenePos)
		trans = trans.translated(Vector3(0, -0.5, 0))
		multimeshInstance.multimesh.set_instance_transform(i, trans)


		# for player to check close coordinate positions
		grassDic[cell] = i
		
		set_cell_item(cell, GridMap.INVALID_CELL_ITEM)


func spawn_grass_particles(position: Vector3) -> void:
	var particleInstance : CPUParticles3D = grassParticleFX.instantiate()
	particleInstance.position = position
	particleInstance.finished.connect(particleInstance.queue_free)
	particleInstance.one_shot = true
	get_parent().add_child.call_deferred(particleInstance)



func play_cut_sfx() -> void:
	var pitches = [0.5, 0.7, 1.0, 1.3, 1.5]
	var randPitch = pitches[randi_range(0, pitches.size() - 1)] * 3
	
	if !%GrassCutSFX:
		push_warning("No GrassCutSFX found as a child of ", self)
	%GrassCutSFX.pitch_scale = randPitch
	%GrassCutSFX.play()
