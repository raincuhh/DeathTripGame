extends ColorRect


func _ready():
	var screen_size = Vector2i(640, 360)
	var shader_material = ShaderMaterial.new()
	var shader = load("res://resources/postProcessing/drunkFilter/drunknessFilter.gdshader")
	shader_material.shader = shader
	shader_material.set_shader_parameter("screen_size", screen_size)
	material = shader_material
	print(screen_size)

