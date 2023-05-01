extends Node


var has_player_stats = false
var has_new_player_position = false
var new_player_position = Vector2(0.0, 0.0)
var player_stats = {
	"speed": 0,
	"max_health": 1,
	"health": 1,
	"damage": 0,
	"prev_velocity": Vector2.ZERO,
	"dash_speed": 0,
	"dash_duration": 0.0,
	"dash_cooldown": 0.0,
	"ghost_cooldown": 0.0
}


# Записываем статы Player'a
func set_player_stats_from(player: KinematicBody2D):
	if !player.is_in_group("player"):
		return
	for property in player_stats.keys():
		player_stats[property] = player.get(property)
	has_player_stats = true

# Передаём статы Player'a новому Player'у
func get_player_stats_to(player: KinematicBody2D):
	if !player.is_in_group("player"):
		return
	for property in player_stats.keys():
		player.set(property, Globals.player_stats[property])

# Сохраняем старую позицию игрока (полезно при смене сцены через дверь)
func set_new_player_pos_from(player: KinematicBody2D):
	if !player.is_in_group("player"):
		return
	new_player_position = player.position
	has_new_player_position = true

# Передаём новую позицию игрока
func set_new_player_pos(value: Vector2):
	new_player_position = value
	has_new_player_position = true

func get_new_player_pos_to(player: KinematicBody2D):
	if !player.is_in_group("player"):
		return
	player.position = new_player_position
	has_new_player_position = false
