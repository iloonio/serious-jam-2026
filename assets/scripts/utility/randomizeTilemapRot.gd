@tool
extends GridMap

@export var trigger_randomization: bool = false:
	get:
		return _trigger_randomization
	set(newVal):
		_trigger_randomization = newVal
		if newVal:  # Only process on true, then auto-reset
			run_randomizer()

var _trigger_randomization: bool = false
var allowed_orientations = [0, 10, 16, 22]


func run_randomizer() -> void:
	# Only run if clicked in the editor, not when starting the game
	if Engine.is_editor_hint():
		randomize_existing_tiles()
	# Always reset the checkbox back to unclicked
	_trigger_randomization = false

func randomize_existing_tiles():
	# Get all used cells in the gridmap
	var used_cells = get_used_cells()

	for cell_coords in used_cells:
		# Get current item at this cell
		var item_id = get_cell_item(cell_coords)
		if item_id == GridMap.INVALID_CELL_ITEM:
			continue

		# Pick a random orientation
		var random_orientation = allowed_orientations[randi() % allowed_orientations.size()]

		# Set the cell with the new orientation
		set_cell_item(cell_coords, item_id, random_orientation)

	# Force gridmap to rebuild visual representation
	# Temporarily swap mesh library to force update
	var mesh_lib = mesh_library
	set_mesh_library(null)
	set_mesh_library(mesh_lib)
