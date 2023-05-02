extends "res://scenes/entity/enemy/EnemyBase.gd"


# Called when the node enters the scene tree for the first time.
func _ready():
	animationTree.active = true

onready var attack_timer = $AttackTimer

onready var animationTree = $AnimationTree


var victim
var attack = false

func engage(player):
	motion = Vector2.ZERO
	if player and is_instance_valid(player):
		#look_at(player.position)
		motion = position.direction_to(player.position)*speed
		
	animationTree.set("parameters/blend_position", motion)
	
	motion = move_and_slide(motion)

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
		
