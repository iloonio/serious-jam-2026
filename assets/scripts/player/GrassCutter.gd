extends Node3D

const SPEED = 5.0
const JUMP_VELOCITY = 4.5

var grassManager: GrassManager

@export var cutRadius: float = 1.0

var cutGrass: Array = []

var isSpinning: bool = false


@export_category("Bandpass Filter")
@export var effectIndex: int = 0

@export var minFreq: float = 1000.0
@export var maxFreq: float = 4500.0


var bandpassFilter: AudioEffectBandPassFilter

func fetch_bandpass_filter() -> void:
	var effect = AudioServer.get_bus_effect(AudioServer.get_bus_index("PlayerSpin"), effectIndex)

	if effect is AudioEffectBandPassFilter:
		bandpassFilter = effect
	else:
		push_error("Effect at index  %d is not a BandPassFilter" % effectIndex)


func spinSFX() -> void:
	if not bandpassFilter:
			return

	# get player rotation
	var playerRot = rotation.y

	# normalize so rotation loops between from 0 to 1
	var normalizedRot = abs(sin(playerRot))

	# map the rotation to the cutoff frequency
	var targetCutoff = lerp(minFreq, maxFreq, normalizedRot)
	bandpassFilter.cutoff_hz = targetCutoff




func _ready() -> void:
	grassManager = get_tree().get_first_node_in_group("GrassManager")
	if not grassManager:
		push_error("GrassManager node not found in ", self)

	fetch_bandpass_filter()


func _process(delta: float) -> void:
	spinSFX()


func _physics_process(delta: float) -> void:
	cut_grass_in_radius()


func cut_grass_in_radius():
	if !isSpinning:
		return

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


func _on_player_is_spinning(flag: bool, speed: float) -> void:
	isSpinning = flag

	if isSpinning:
		if %SpinSFX.playing == false:
			%SpinSFX.play()
	else:
		if %SpinSFX.playing == true:
			%SpinSFX.stop()


func _on_player_body_entered(body: Node) -> void:
	print(body, "BPDY")


func _on_player_body_shape_entered(body_rid: RID, body: Node, body_shape_index: int, local_shape_index: int) -> void:
	print(body, "BPDY")
