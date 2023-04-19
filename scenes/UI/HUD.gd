extends CanvasLayer


onready var heartsBar = $HeartsBar


func set_HP(value):
	heartsBar.half_hearts = value

func set_max_HP(value):
	heartsBar.max_half_hearts = value
