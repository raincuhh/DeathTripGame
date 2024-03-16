extends Button




func _on_pressed():
	signalBus.emit_signal("restartGame")
	print("restarted")
