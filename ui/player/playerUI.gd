extends CanvasLayer

@onready var scoreLabel = $scoreUi/MarginContainer/VBoxContainer/HBoxContainer/score
@onready var drunknessBar = $drunknessBarUi/Sprite2D
@onready var drunknessAnimationPlayer = $drunknessBarUi/AnimationPlayer
@onready var drunknessFilter = $DrunknessFilter


func _ready():
	updateDrunknessLevel(0)

func updateScoreLabel(score: int):
	var labelNumberPadding = 7
	if not scoreLabel:
		print("not drunknessbar")
		return
	scoreLabel.text = str(score).pad_zeros(labelNumberPadding)
	global.globalScore = score

func updateDrunknessLevel(drunknessLevel: int):
	if not drunknessBar:
		print("not drunknessbar")
		return
	match(drunknessLevel):
		0:
			drunknessAnimationPlayer.play("EMPTY")
		1:
			drunknessAnimationPlayer.play("1OUTOF5FULL")
		2:
			drunknessAnimationPlayer.play("2OUTOF5FULL")
		4:
			drunknessAnimationPlayer.play("3OUTOF5FULL")
		5:
			drunknessAnimationPlayer.play("4OUTOF5FULL")
		6:
			drunknessAnimationPlayer.play("FULL")
			global.canDrive = false
	
	var colorRect = drunknessFilter.get_node("ColorRect")
	if colorRect.material:
		colorRect.material.set_shader_parameter("distortion_amount", computeDistortionAmount(drunknessLevel))
		colorRect.material.set_shader_parameter("blur_amount", computeBlurAmount(drunknessLevel))

func computeDistortionAmount(drunknessLevel: int) -> float:
	return 0.1 * drunknessLevel
	#print("changed drunknessLevelDistortion")

func computeBlurAmount(drunknessLevel: int) -> float:
	return 0.1 * drunknessLevel
	#print("changed drunknessLevelBlur")
