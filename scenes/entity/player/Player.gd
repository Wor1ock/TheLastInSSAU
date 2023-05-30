extends "res://scenes/entity/EntityBase.gd"

enum {
	MOVE,
	DASH,
	ATTACK
}


var state = MOVE
var prev_velocity := Vector2.RIGHT

export(int) var dash_speed := 900
export(float) var dash_duration := 0.2
export(float) var dash_cooldown := 0.5
export(float) var ghost_cooldown := 0.03


onready var animationPlayer = $AnimationPlayer
onready var animationTree = $AnimationTree
onready var animationState = animationTree.get("parameters/playback")
onready var sprite = $Sprite
onready var dash = $Dash
onready var hurtbox = $HurtboxShape
onready var gameOverScreen = $GameOverScreen


func _ready():
	animationTree.active = true
	gameOverScreen.hide()
	
	self.damage = damage
	
	# Нужно для инициализации HeartsBar
	self.health = health
	self.max_health = max_health
	
	# Записываем статы в Globals
	# Либо копируем их оттуда при переходе на другой уровень
	if Globals.has_player_stats:
		Globals.get_player_stats_to(self)
		animationTree.set("parameters/Idle/blend_position", prev_velocity)
		animationTree.set("parameters/Run/blend_position", prev_velocity)
		animationTree.set("parameters/Attack/blend_position", prev_velocity)
	else:
		Globals.set_player_stats_from(self)
	
	# После перехода с предыдущей сцены меняем положение Player
	if Globals.has_new_player_position:
		Globals.get_new_player_pos_to(self)

func _physics_process(_delta):
	match state:
		MOVE:
			movement_control()
		ATTACK:
			attack_state()
		DASH:
			dash_state()

# Функция для управления движением и анимацией
func movement_control():
	# Направление движения персонажа
	velocity = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	
	if velocity != Vector2.ZERO:
		prev_velocity = velocity
		animationTree.set("parameters/Idle/blend_position", velocity)
		animationTree.set("parameters/Run/blend_position", velocity)
		animationTree.set("parameters/Attack/blend_position", velocity)
		animationState.travel("Run")
	else:
		animationState.travel("Idle")
	# Функция, осуществляющая перемещение
	velocity = move_and_slide(velocity * speed)
	
	if Input.is_action_just_pressed("attack"):
		var rand_hit = floor(rand_range(0,2))
		match str(rand_hit):
			"0":
				Globals.play_sound("res://sounds/кия.mp3")
			"1":
				Globals.play_sound("res://sounds/Получаай.mp3")
		state = ATTACK
	elif Input.is_action_just_pressed("dash"):
		if dash.start_dash(dash_duration, dash_cooldown, ghost_cooldown, sprite):
			hurtbox.set_invulnerability(true)
			Globals.play_sound("res://sounds/уворот.mp3")
			state = DASH

# Функция для контроля аттаки
func attack_state():
	animationState.travel("Attack")
	
func attack_animation_finished():
	state = MOVE

func dash_state():
	move_and_slide(prev_velocity * dash_speed)

func dash_finished():
	hurtbox.set_invulnerability(false)
	state = MOVE

# Непосредственное нанесение урона
func _on_HitboxShape_area_entered(body):
	if body.has_method("hurtbox_take_damage"):
		Globals.play_sound("res://sounds/ударпо_роботу.mp3")
		body.hurtbox_take_damage(damage)

# Вызывается при смерти персонажа
func die():
	emit_signal("died")
	gameOverScreen.show()
	get_tree().paused = true
