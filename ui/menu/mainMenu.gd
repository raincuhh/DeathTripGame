extends CanvasLayer

#screens
@onready var playScreen = $Control/margin5px/playScreen
@onready var settingsScreen = $Control/margin5px/settingsScreen

#playScreen
@onready var start = $Control/margin5px/playScreen/play/VBoxContainer/start
@onready var settings = $Control/margin5px/playScreen/buttons/HBoxContainer/settings

var fullScreen = false
var borderless = false

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

func _process(delta):
	if Input.is_action_just_pressed("FULLSCREEN"):
		if fullScreen:
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
		else:
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
		fullScreen = !fullScreen

func _on_start_pressed():
	initiateGame()


func _on_full_screen_pressed():
	if fullScreen:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
	else:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
	fullScreen = !fullScreen


func _on_borderless_pressed():
	if borderless:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
	else:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_EXCLUSIVE_FULLSCREEN)
	borderless = !borderless


func _on_back_pressed():
	handleShowHide(settingsScreen, playScreen)
