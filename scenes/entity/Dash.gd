extends Node


signal dash_finished()


onready var durationTimer = $DurationTimer


func start_dash(duration):
	durationTimer.wait_time = duration
	durationTimer.start()

func _on_DurationTimer_timeout():
	emit_signal("dash_finished")
