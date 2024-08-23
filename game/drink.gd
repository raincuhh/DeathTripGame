extends Area2D

@onready var drink = $"."

func _on_body_entered(body):
	drink.hide()
