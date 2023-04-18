extends Node


signal dash_finished()


onready var durationTimer = $DurationTimer
onready var cooldownTimer = $CooldownTimer


var dash_not_ready := false


func start_dash(duration, cooldown) -> bool:
	if dash_not_ready:
		return false
	dash_not_ready = true
	cooldownTimer.wait_time = cooldown
	durationTimer.wait_time = duration
	durationTimer.start()
	return true

func _on_DurationTimer_timeout():
	cooldownTimer.start()
	emit_signal("dash_finished")

func _on_CooldownTimer_timeout():
	dash_not_ready = false
