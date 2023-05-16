extends "res://scenes/entity/enemy/EnemyBase.gd"


# Called when the node enters the scene tree for the first time.
func _ready():
	animationTree.active = true

onready var attack_timer = $AttackTimer

onready var animationTree = $AnimationTree
onready var animationPlayer = $AnimationPlayer
onready var hitboxShape = $Position2D/HitboxShape
onready var animationState = animationTree.get("parameters/playback")

var victim
var attack = false

enum {
	MOVE,
	ATTACK
}

var state = MOVE

#func engage(player):
#	animationTree.active = true
#	motion = Vector2.ZERO
#	if player and is_instance_valid(player):
#		#look_at(player.position)
#		motion = position.direction_to(player.position)*speed
#
#	animationTree.set("parameters/blend_position", motion)
#
#	motion = move_and_slide(motion)
#	#animationState.travel("Idle")
	
func engage(player):
	match state:
		MOVE:
			motion = Vector2.ZERO
			if player and is_instance_valid(player):
				hitboxShape.look_at(player.position)
				#look_at(player.position)
				motion = position.direction_to(player.position)*speed
				
			if motion != Vector2.ZERO:
				animationTree.set("parameters/Idle/blend_position", motion)
				animationTree.set("parameters/Attack/blend_position", motion)
				animationState.travel("Idle")
			
			motion = move_and_slide(motion)
		ATTACK:
			animationState.travel("Attack")
			

func _on_HitboxShape_area_entered(body):
	if body.has_method("hurtbox_take_damage"):
		attack_timer.start()
		#body.hurtbox_take_damage(damage)
		victim = body
		attack = true
		state = ATTACK
		


func _on_AttackTimer_timeout():
	if attack == true:
		victim.hurtbox_take_damage(damage)
		attack_timer.start()
	


func _on_HitboxShape_area_exited(body):
	if body == victim:
		attack = false
		state = MOVE
		
		
