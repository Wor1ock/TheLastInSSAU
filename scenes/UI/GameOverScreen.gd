extends CanvasLayer


func _on_RestartButton_pressed():
	get_tree().paused = false
	get_tree().change_scene("res://scenes/maps/FirstFloor.tscn")


func _on_QuitButton_pressed():
	get_tree().quit()
