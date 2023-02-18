extends KinematicBody2D


signal state_changed(new_state)

# Перечисление состояний: 
# PATROL - патрулирование
# ENGAGE - вступление в бой
enum State {
	PATROL,
	ENGAGE
}

onready var player_detection_zone = $PlayerDetectionZone
onready var patrol_timer = $PatrolTimer

# Переменные для ENGAGE
var speed = 270
var motion = Vector2.ZERO


var current_state: int = -1 setget set_state
var player = null

# Переменные для PATROL 
var origin: Vector2 = Vector2.ZERO 
var patrol_location: Vector2 = Vector2.ZERO 
var velocity: Vector2 = Vector2.ZERO 
var patrol_location_reached = false

func _ready():
	set_state(State.PATROL)

func _physics_process(delta):
	match current_state:
		State.PATROL:
			if not patrol_location_reached:
				move_and_slide(velocity)
				if global_position.distance_to(patrol_location) < 5:
					patrol_location_reached = true
					velocity = Vector2.ZERO
					patrol_timer.start()
		State.ENGAGE:
			engage(player)

func set_state(new_state: int):
	if new_state == current_state:
		return
	if new_state == State.PATROL:
		origin = global_position
		patrol_timer.start()
		patrol_location_reached = true
	current_state = new_state
	print(new_state)
	emit_signal("state_changed", current_state)

	
func _on_PlayerDetectionZone_body_entered(body: Node) -> void:
	if body.is_in_group("player"):
		set_state(State.ENGAGE)
		player = body
		print("enter")


func _on_PlayerDetectionZone_body_exited(body):
	if player and body == player:
		set_state(State.PATROL) 
		player = null
		print("exit")

func engage(player):
	motion = Vector2.ZERO
	if player:
		motion = position.direction_to(player.position)*speed
	motion = move_and_slide(motion)



func _on_PatrolTimer_timeout():
	var patrol_range = 50
	var random_x = rand_range(-patrol_range, patrol_range)
	var random_y = rand_range(-patrol_range, patrol_range)
	patrol_location = Vector2(random_x,random_y) + origin
	patrol_location_reached = false
	velocity = global_position.direction_to(patrol_location) * 100
