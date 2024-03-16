extends CanvasLayer

#screens
@onready var playScreen = $Control/margin5px/playScreen
@onready var settingsScreen = $Control/margin5px/settingsScreen

#playScreen
@onready var start = $Control/margin5px/playScreen/play/VBoxContainer/start
@onready var settings = $Control/margin5px/playScreen/buttons/HBoxContainer/settings

signal startGame

func handleShowHide(a, b):
	a.hide()
	b.show()

func initiateGame():
	emit_signal("startGame")
	queue_free()

#playScreen
func _on_settings_pressed():
	handleShowHide(playScreen, settingsScreen)


func _on_start_pressed():
	initiateGame()
