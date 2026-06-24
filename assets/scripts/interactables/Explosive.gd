

## Explosive Component is supposed to have an Area3D
## This area 3D scans for rigidbodies, and then applies
## a central impulse to those objects from its parent's origin point
## Note that the Explosive Component itself only handles chaining
## interactions and creating impulses! to give the explosion feedback,
## you should add an FxComponent as well, unless your explosive object
## has a breakable component, in which case it is entirely optional.
## ## Notes
## - if the explosive object isn't static, it will also get exploded away.
##
## ExplosiveComponent
## └── Area3D
##     └── CollisionShape (Sphere)
@tool
class_name Explosive extends Interactable

@export_range(0.5, 8, 0.25) var effectRadius: float = 1:
	get: return effectRadius
	set(newValue):
		effectRadius = newValue


## whether the explosion will also make an OnInteract call.
@export var callOn_interact: bool = true

@export_range(0, 36, 0.5) var Impulse = 4

@export var explosionArea: Area3D

func on_interact() -> void:
	pass
