extends KinematicBody2D

# Movement speed in pixels per second.
export var speed := 5

var direction := Vector2.ZERO

onready var _animated_sprite = $AnimatedSprite

var _state = "front"

# Про анимирование всего этого добра можно почитать тут:
# https://www.gdquest.com/tutorial/godot/2d/top-down-movement/
# Раздел Top-down movement


func _physics_process(_delta):
	movement_control()
	animation_control()

# Функция для управления движением
func movement_control():
	# Направление движения персонажа
	direction = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	# Функция, осуществляющая перемещение
	direction = move_and_slide(direction * speed)
	
func animation_control():
	if Input.is_action_pressed("ui_right"):
		_animated_sprite.play("walk_right")
		_animated_sprite.flip_h = false
		_state = "right"
	elif Input.is_action_pressed("ui_left"):
		_animated_sprite.play("walk_right")
		_animated_sprite.flip_h = true
		_state = "left"
	elif Input.is_action_pressed("ui_up"):
		_animated_sprite.play("walk_back")
		_state = "back"
	elif Input.is_action_pressed("ui_down"):
		_animated_sprite.play("walk_front")
		_state = "front"
	elif Input.is_action_pressed("ui_cancel"):
		_animated_sprite.play("death_right")
		match _state:
			"right":
				_animated_sprite.flip_h = false
			"left":
				_animated_sprite.flip_h = true
	elif Input.is_action_pressed("ui_accept"):
		match _state:
			"front":
				_animated_sprite.play("attack_front")
			"back":
				_animated_sprite.play("attack_back")
			"right":
				_animated_sprite.play("attack_right")
				_animated_sprite.flip_h = false
			"left":
				_animated_sprite.play("attack_right")
				_animated_sprite.flip_h = true
	else:
		match _state:
			"front":
				_animated_sprite.play("idle_front")
			"back":
				_animated_sprite.play("idle_back")
			"right":
				_animated_sprite.play("idle_right")
				_animated_sprite.flip_h = false
			"left":
				_animated_sprite.play("idle_right")
				_animated_sprite.flip_h = true
				
