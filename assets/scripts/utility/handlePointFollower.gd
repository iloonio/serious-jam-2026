extends Node3D

@export var path: Path3D

@export var idx: int = 1

var _curve: Curve3D

func _ready() -> void:
	_curve = path.curve


func _on_bezier_path_3d_curve_changed() -> void:
	self.transform.origin = path.curve.get_point_position(idx) + path.curve.get_point_in(idx)
