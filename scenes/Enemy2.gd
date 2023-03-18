extends KinematicBody2D


onready var player_detection_zone = $PlayerDetectionZone


# Переменные для ENGAGE
var speed = 120
var motion = Vector2.ZERO
var player = null


# Функция определяет поведение врага в разных состояниях
func _physics_process(delta):
	motion = Vector2.ZERO
	if player:
		motion = position.direction_to(player.position)*speed
	motion = move_and_slide(motion)
	
	
func _on_PlayerDetectionZone_body_entered(body: Node) -> void:
	if body.is_in_group("player"):
		player = body
		print("enter")



func _on_HurtboxShape_area_entered(area):
	queue_free()
