extends "res://scenes/entity/EntityBase.gd"




onready var player_detection_zone = $PlayerDetectionZone


onready var timer = $Timer
var motion = Vector2.ZERO
var player = null


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func engage(player):
	motion = Vector2.ZERO
	if player and is_instance_valid(player):
		look_at(player.position)
		motion = position.direction_to(player.position)*speed
	motion = move_and_slide(motion)


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func _on_PlayerDetectionZone_body_entered(body):
		if body.is_in_group("player"):
			player = body


func _on_PlayerDetectionZone_body_exited(body):
	pass # Replace with function body.


func _on_Timer_timeout():
	pass # Replace with function body.
