extends Node2D

const winScreen = preload("res://scenes/UI/WinScreen.tscn")

func _on_BigBoss_died():
	var you_won = winScreen.instance()
	add_child(you_won)
	get_tree().paused = true
