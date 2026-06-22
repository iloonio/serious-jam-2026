extends ShapeCast3D

## a signal notifying that collisionNormals have indeed been detected.
## this signal can be used for playing sounds, VFX, or handling physics
signal collisionNormals(colliderNormals: Array[Vector3])

@onready var prevColCount: int = 0
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(_delta: float) -> void:
	prevColCount = get_collision_count()
	if is_colliding() and (get_collision_count() != prevColCount):
		collisionNormals.emit(getColliderNormals())

# if you wanna do something related to collisionNormals, use this function as a template
# and then call it in _physics_process
func getColliderNormals() -> Array[Vector3]:
	var normals: Array[Vector3] = []
	for idx in get_collision_count() - 1:
		normals.append(get_collision_normal(idx))

	return normals
