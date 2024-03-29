extends Area2D


export(float) var new_player_x = 0.0
export(float) var new_player_y = 0.0
export(String, FILE, "*.tscn,*.scn") var file_path setget set_file_path


func set_file_path(p_value):
	if typeof(p_value) == TYPE_STRING and p_value.get_extension() in ["tscn", "scn"]:
		var d = Directory.new()
		if not d.file_exists(p_value):
			return
		file_path = p_value



func _on_DoorToNextLevel_Player_entered(body):
	if body.is_in_group("player"):
		Globals.play_sound("res://sounds/Пуф2.mp3")
		yield(get_tree().create_timer(0.1), "timeout")
		Globals.set_player_stats_from(body)
		Globals.set_new_player_pos(Vector2(new_player_x, new_player_y))
		get_tree().change_scene(file_path)
