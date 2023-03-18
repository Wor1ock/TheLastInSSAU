extends KinematicBody2D

onready var patrol_timer = $PatrolTimer

export var mini_enemy: PackedScene
export var basic_enemy:PackedScene
export var nemesis:PackedScene
export var spawner:PackedScene

var speed = 12
var motion = Vector2.ZERO
var player = null
var dead = false

func _ready():
	patrol_timer.start()
	
# Функция определяет поведение врага в разных состояниях
func _physics_process(delta):
	if dead==true:
		spawn()
		dead=false


func _on_HurtboxShape_area_entered(area):
	queue_free()
	dead = true
	
func spawn ():
	var test_level=get_node("..")
	var inst = [mini_enemy.instance(), basic_enemy.instance(), nemesis.instance(), spawner.instance()]
	var i = rand_range(0,4)
	test_level.add_child(inst[i])
	var pos = [$pos.global_transform, $pos2.global_transform, $pos3.global_transform,$pos4.global_transform,$pos5.global_transform,$pos6.global_transform]
	var j = rand_range(0,6)
	inst[i].transform=pos[j]
	


func _on_PatrolTimer_timeout():
	spawn()
	patrol_timer.start()


