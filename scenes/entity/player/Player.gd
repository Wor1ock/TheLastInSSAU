extends "res://scenes/entity/EntityBase.gd"

enum {
	MOVE,
	ROLL,
	ATTACK
}


var direction := Vector2.ZERO
var state = MOVE


onready var animationPlayer = $AnimationPlayer
onready var animationTree = $AnimationTree
onready var animationState = animationTree.get("parameters/playback")

func _ready():
	animationTree.active = true
	$AttackDirection/HitboxShape.damage = damage
#	$AttackDirection/HitboxShape/CollisionShape2D.disabled = true

# Про анимирование всего этого добра можно почитать тут:
# https://www.gdquest.com/tutorial/godot/2d/top-down-movement/
# Раздел Top-down movement

func _physics_process(_delta):
	match state:
		MOVE:
			movement_control()
		ATTACK:
			attack_state()
		ROLL:
			pass

# Функция для управления движением и анимацией
func movement_control():
	# Направление движения персонажа
	direction = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	
	if direction != Vector2.ZERO:
		animationTree.set("parameters/Idle/blend_position", direction)
		animationTree.set("parameters/Run/blend_position", direction)
		animationTree.set("parameters/Attack/blend_position", direction)
		animationState.travel("Run")
	else:
		animationState.travel("Idle")
	# Функция, осуществляющая перемещение
	direction = move_and_slide(direction * speed)
	
	if Input.is_action_just_pressed("ui_accept"):
		state = ATTACK

# Функция для контроля аттаки
func attack_state():
	animationState.travel("Attack")
	
func attack_animation_finished():
	state = MOVE
