extends Node2D

onready var dialogMark = $ActiveDialogueMark

var is_active = false

func _process(_delta):
	dialogMark.visible = is_active

func _on_DialogueZone_body_entered(body):
	if body.is_in_group("player"):
		is_active = true

func _on_DialogueZone_body_exited(body):
	if body.is_in_group("player"):
		is_active = false
