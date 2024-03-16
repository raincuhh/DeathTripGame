extends CanvasLayer

@onready var highscore = $Control/HBoxContainer/VBoxContainer/HBoxContainer/highscore/highscore

func _on_reset_pressed():
	signalBus.emit_signal("restartGame")
