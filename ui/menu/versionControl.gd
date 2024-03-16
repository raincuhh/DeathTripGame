extends Control

@onready var versionLabel = $VBoxContainer/version


func _ready():
	versionLabel.text = "V" + str(global.currentVersion)
