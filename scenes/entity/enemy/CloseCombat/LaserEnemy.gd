extends "res://scenes/entity/enemy/CloseCombat/CloseCombat.gd"



signal state_changed(new_state)

# Перечисление состояний: 
# PATROL - патрулирование
# ENGAGE - вступление в бой
enum State {
	PATROL,
	ENGAGE
}

onready var patrol_timer = $Timer


var current_state: int = -1 setget set_state

# Переменные для PATROL 
var origin: Vector2 = Vector2.ZERO 
var patrol_location: Vector2 = Vector2.ZERO 

var patrol_location_reached = false

func _ready():
	set_state(State.PATROL)

var st=true
# Функция определяет поведение врага в разных состояниях
func _physics_process(delta):
	if st==true:
		set_state(State.PATROL)
		patrol_timer.start()
		st=false
	match current_state:
		State.PATROL:
			if not patrol_location_reached:
				var v = move_and_slide(velocity)
				if global_position.distance_to(patrol_location) < 5 or global_position.distance_to(patrol_location)>300:
					patrol_location_reached = true
					velocity = Vector2.ZERO
					patrol_timer.start()
		State.ENGAGE:
			engage(player)


# Функция смены состояния
func set_state(new_state: int):
	if new_state == State.PATROL:
		origin = global_position
		patrol_timer.start()
		patrol_location_reached = true
	current_state = new_state
	print(new_state)
	emit_signal("state_changed", current_state)

	
# Смена состояния, если враг увидел игрока	
func _on_PlayerDetectionZone_body_entered(body: Node) -> void:
	if body.is_in_group("player"):
		set_state(State.ENGAGE)
		player = body
		print("enter")


# Смена состояния, если враг потерял игрока	
func _on_PlayerDetectionZone_body_exited(body):
	if player and body == player:
		set_state(State.PATROL) 
		player = null
		print("exit")


# Генерация случайного места назначения для патрулирования
func _on_Timer_timeout():
	var patrol_range = 300
	var random_x = rand_range(-patrol_range, patrol_range)
	var random_y = rand_range(-patrol_range, patrol_range)
	patrol_location = Vector2(random_x,random_y) + origin
	patrol_location_reached = false
	velocity = global_position.direction_to(patrol_location) * 50

