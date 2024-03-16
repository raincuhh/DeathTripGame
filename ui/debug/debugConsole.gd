extends CanvasLayer

@onready var fpsLabel = $Control/margin5px/VBoxContainer/fps
@onready var speedLabel = $Control/margin5px/VBoxContainer/speed


func _process(delta):
	var fps = Engine.get_frames_per_second()
	fpsLabel.text = "FPS: " + str(fps)
	speedLabel.text = "speed: " + str(global.speed) + "/" +str(global.maxSpeed)
