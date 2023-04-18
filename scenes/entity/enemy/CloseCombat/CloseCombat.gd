extends "res://scenes/entity/enemy/EnemyBase.gd"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

onready var attack_timer = $AttackTimer


var victim
var attack = false

func _on_HitboxShape_area_entered(body):
	if body.has_method("hurtbox_take_damage"):
		attack_timer.start()
		#body.hurtbox_take_damage(damage)
		victim = body
		attack = true
		


func _on_AttackTimer_timeout():
	if attack == true:
		victim.hurtbox_take_damage(damage)
		attack_timer.start()
	


func _on_HitboxShape_area_exited(body):
	if body == victim:
		attack = false
		
