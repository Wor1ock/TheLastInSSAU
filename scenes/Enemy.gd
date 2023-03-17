extends KinematicBody2D


signal state_changed(new_state)
signal health_updated(health)
signal killed()

# Перечисление состояний: 
# PATROL - патрулирование
# ENGAGE - вступление в бой
enum State {
	PATROL,
	ENGAGE
}

onready var player_detection_zone = $PlayerDetectionZone
onready var patrol_timer = $PatrolTimer
onready var invulnerability_timer = $InvulnerabilityTimer
onready var hp_label = $HPLabel

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

# Очки здоровья
export(int) var max_health := 25
onready var health := max_health setget  _set_health


func _ready():
	hp_label.text = str(health)
	set_state(State.PATROL)


# Функция определяет поведение врага в разных состояниях
func _physics_process(delta):
	match current_state:
		State.PATROL:
			if not patrol_location_reached:
				var v = move_and_slide(velocity)
				if global_position.distance_to(patrol_location) < 5 or global_position.distance_to(patrol_location)>50:
					patrol_location_reached = true
					velocity = Vector2.ZERO
					patrol_timer.start()
		State.ENGAGE:
			engage(player)


# Функция смены состояния
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


# Функция вступления в бой (пока что только бега за игроком)
func engage(player):
	motion = Vector2.ZERO
	if player:
		motion = position.direction_to(player.position)*speed
	motion = move_and_slide(motion)


# Генерация случайного места назначения для патрулирования
func _on_PatrolTimer_timeout():
	var patrol_range = 50
	var random_x = rand_range(-patrol_range, patrol_range)
	var random_y = rand_range(-patrol_range, patrol_range)
	patrol_location = Vector2(random_x,random_y) + origin
	print(patrol_location)
	patrol_location_reached = false
	velocity = global_position.direction_to(patrol_location) * 100

# Вызывается при смерти персонажа
func kill():
	queue_free()

# Получение урона
func damage(amount):
	if invulnerability_timer.is_stopped():
		invulnerability_timer.start()
		_set_health(health - amount)

# Изменение здоровья
func _set_health(value):
	var prev_health := health
	health = clamp(value, 0, max_health)
	if health != prev_health:
		emit_signal("health_updated", health)
		if health == 0:
			kill()
			emit_signal("killed")

func _on_HurtboxShape_area_entered(area):
	damage(area.damage)


func _on_Enemy_health_updated(health):
	hp_label.text = str(health)
