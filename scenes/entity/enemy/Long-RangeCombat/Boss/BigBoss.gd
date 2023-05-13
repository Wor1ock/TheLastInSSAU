extends "res://scenes/entity/enemy/EnemyBase.gd"


export(PackedScene) var BULLET: PackedScene = null
export var mini_enemy: PackedScene
export var laser_enemy:PackedScene
export var big_enemy:PackedScene
export var spawner:PackedScene


onready var gunSprite = $GunSprite
onready var rayCast = $RayCast2D
onready var reloadTimer = $RayCast2D/ReloadTimer

var in_shooting_zone = false
func _ready():
	yield(get_tree(), "idle_frame")
	set_state(State.PATROL)
	#target = find_target()

func attack():
	if player != null:
		var angle_to_target: float = global_position.direction_to(player .global_position).angle()
		rayCast.global_rotation = angle_to_target
		if rayCast.is_colliding():
			gunSprite.rotation = angle_to_target
			if reloadTimer.is_stopped():
				shoot()
		else:
			if in_shooting_zone == false: 
				engage(player)		
func shoot():
	
	rayCast.enabled = false
	
	if BULLET:
		var bullet: Node2D = BULLET.instance()
		get_tree().current_scene.add_child(bullet)
		bullet.global_position = global_position
		bullet.global_rotation = rayCast.global_rotation
	
	reloadTimer.start()
	
func _on_ReloadTimer_timeout():
	rayCast.enabled = true
	
signal state_changed(new_state)

# Перечисление состояний: 
# PATROL - патрулирование
# ENGAGE - вступление в бой
enum State {
	PATROL,
	ENGAGE
}

onready var patrol_timer = $Timer

onready var spawn_timer = $SpawnTimer


var current_state: int = -1 setget set_state

# Переменные для PATROL 
var origin: Vector2 = Vector2.ZERO 
var patrol_location: Vector2 = Vector2.ZERO 

var patrol_location_reached = false


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
			attack()


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
		


func _on_SpawnTimer_timeout():
	spawn()
	spawn_timer.start()
	
func spawn (): 
	var test_level=get_node("..")
	var inst = [mini_enemy.instance(), laser_enemy.instance(), spawner.instance()]
	var i = rand_range(0,3)
	test_level.add_child(inst[i])
	var pos = [$pos.global_transform, $pos2.global_transform, $pos3.global_transform,$pos4.global_transform]
	var pos_= rand_range(0,4)
	inst[i].transform=pos[pos_]




func _on_ShootingZone_body_entered(body):
	if body.is_in_group("player"):
		in_shooting_zone = true


func _on_ShootingZone_body_exited(body):
	if player and body == player:
		in_shooting_zone = false
