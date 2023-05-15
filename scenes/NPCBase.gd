extends Node2D

signal timeline_finished(timeline_name)

onready var dialogMark = $ActiveDialogueMark

export(String) var timelineName = "StartTimeline"

var is_active = false


func _process(_delta):
	dialogMark.visible = is_active

func _input(event):
	if get_node_or_null("DialogNode") == null:
		if event.is_action_pressed("ui_accept") and is_active:
			get_tree().paused = true
			var dialog = Dialogic.start(timelineName)
			dialog.pause_mode = Node.PAUSE_MODE_PROCESS
			dialog.connect("timeline_end", self, "_timeline_finished")
			dialog.connect("dialogic_signal", self, "_change_timeline")
			add_child(dialog)

func _on_DialogueZone_body_entered(body):
	if body.is_in_group("player"):
		is_active = true

func _on_DialogueZone_body_exited(body):
	if body.is_in_group("player"):
		is_active = false

func _timeline_finished(timeline_name):
	get_tree().paused = false
	emit_signal("timeline_finished", timeline_name)

func _change_timeline(timeline_name: String):
	self.timelineName = timeline_name
