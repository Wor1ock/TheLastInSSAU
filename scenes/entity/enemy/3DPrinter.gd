extends "res://scenes/entity/enemy/EnemyBase.gd"


export var mini_enemy: PackedScene
export var laser_enemy:PackedScene
export var big_enemy:PackedScene
export var spawner:PackedScene

enum {
	IDLE,
	HIDE
}

var state = IDLE

onready var animationPlayer = $AnimationPlayer
var stop = false
var stop_pos
var pos_
func _ready():
	match state:
		IDLE:
			animationPlayer.play("Idle")
			timer.start()
		HIDE:
			timer.stop()
			animationPlayer.play("Hide")
	

	
func spawn ():
	var test_level=get_node("..")
	var inst = [mini_enemy.instance(), laser_enemy.instance(), spawner.instance()]
	var i = rand_range(0,3)
	test_level.add_child(inst[i])
	var pos = [$pos.global_transform, $pos2.global_transform, $pos3.global_transform,$pos4.global_transform,$pos5.global_transform]
	pos_= rand_range(0,5)
	inst[i].transform=pos[pos_]
	


func _on_Timer_timeout():
	#if state != HIDE:
	spawn()
	timer.start()
	
	
func _on_PlayerDetectionZone_body_entered(body):
	state = HIDE
			
			

func _on_PlayerDetectionZone_body_exited(body):
	state = IDLE




