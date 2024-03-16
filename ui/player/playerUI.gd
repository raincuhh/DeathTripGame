extends CanvasLayer

@onready var scoreLabel = $Control/MarginContainer/VBoxContainer/HBoxContainer/score

var labelNumberPadding = 7

func updateScoreLabel(score: int):
	if not scoreLabel:
		print("incorrect reference")
		return
	scoreLabel.text = str(score).pad_zeros(labelNumberPadding)


