extends CanvasLayer


@onready var score = $Control/HBoxContainer/VBoxContainer/HBoxContainer/score/score


func updateGlobalScoreLabel():
	var labelNumberPadding = 7
	if not score:
		print("not drunknessbar")
		return
	score.text = str(global.globalScore).pad_zeros(labelNumberPadding)
	print(global.globalScore)
	#updateGlobalHighscoreLabel()

func updateGlobalHighscoreLabel():
	var labelNumberPadding = 7
	if global.globalScore > global.highScore:
		global.highScore = global.globalScore
	

func _on_reset_pressed():
	signalBus.emit_signal("restartGame")



func _on_exit_pressed():
	get_tree().quit()
