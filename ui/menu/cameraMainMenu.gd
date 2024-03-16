extends Camera2D


@export var smoothLean := 12.0
@export var scaleLean := 0.10

func lean_camera_towards_mouse_(delta: float) -> void:
	var mousePosition := get_global_mouse_position()
	
	var directionToMouse := (mousePosition - position).normalized()
	var distanceToMouse := mousePosition.distance_to(position)
	var lean := directionToMouse * distanceToMouse * scaleLean
	
	offset = lerp(offset, lean, delta * smoothLean)

func _process(delta):
	lean_camera_towards_mouse_(delta)
