extends Node2D


signal dash_finished()


onready var durationTimer = $DurationTimer
onready var cooldownTimer = $CooldownTimer
onready var ghostTimer = $GhostTimer
var ghost_scene = preload("res://scenes/entity/DashGhost.tscn")

var dash_not_ready := false
var sprite


func start_dash(duration, cooldown, ghost_cooldown, sprite) -> bool:
	if dash_not_ready:
		return false
	
	# Отсюда будем брать текущий кадр анимации для остаточного изображения
	self.sprite = sprite
	
	dash_not_ready = true
	ghostTimer.wait_time = ghost_cooldown
	cooldownTimer.wait_time = cooldown
	durationTimer.wait_time = duration
	durationTimer.start()
	ghostTimer.start()
	
	instance_ghost()
	return true

# Создаём одно остаточное изображение
func instance_ghost():
	var ghost: Sprite = ghost_scene.instance()
	add_child(ghost)
	
	# Делаем ghost недвижимым
	ghost.set_as_toplevel(true)
	ghost.global_position = global_position
	
	# Подбираем нужный фрейм
	ghost.texture = sprite.texture
	ghost.vframes = sprite.vframes
	ghost.hframes = sprite.hframes
	ghost.frame = sprite.frame
	ghost.flip_h = sprite.flip_h
	ghost.flip_v = sprite.flip_v
	ghost.scale = sprite.scale

func _on_DurationTimer_timeout():
	cooldownTimer.start()
	ghostTimer.stop()
	emit_signal("dash_finished")

func _on_CooldownTimer_timeout():
	dash_not_ready = false


func _on_GhostTimer_timeout():
	print(ghostTimer.wait_time)
	instance_ghost()
