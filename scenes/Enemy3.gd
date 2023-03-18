extends KinematicBody2D

onready var player_detection_zone = $PlayerDetectionZone
onready var patrol_timer = $PatrolTimer

export var mini_enemy: PackedScene

var speed = 120
var motion = Vector2.ZERO
var player = null
var dead = false

# Функция определяет поведение врага в разных состояниях
func _physics_process(delta):
	#if ()
	motion = Vector2.ZERO
	if player:
		motion = position.direction_to(player.position)*speed
	motion = move_and_slide(motion)
	if dead==true:
		spawn()
		dead=false
	
func _on_PlayerDetectionZone_body_entered(body: Node) -> void:
	if body.is_in_group("player"):
		player = body


func _on_HurtboxShape_area_entered(area):
	queue_free()
	dead = true
	
func spawn ():
	
#	var inst = mini_enemy.new()
#	owner.add_child(inst.instance)
#	inst.transform=$Position2D.global_transform
   
	 
	var inst1= mini_enemy.instance()
	var inst2= mini_enemy.instance()
	var tl=get_node("..")
	tl.add_child(inst1)
	tl.add_child(inst2)
	inst1.transform=$Position2D.global_transform
	inst2.transform=$Position2D2.global_transform
