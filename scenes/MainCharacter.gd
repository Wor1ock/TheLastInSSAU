extends KinematicBody2D

# Movement speed in pixels per second.
export var speed := 500

var direction := Vector2.ZERO

# Про анимирование всего этого добра можно почитать тут:
# https://www.gdquest.com/tutorial/godot/2d/top-down-movement/
# Раздел Top-down movement


func _physics_process(_delta):
	movement_control()

# Функция для управления движением
func movement_control():
	# Направление движения персонажа
	direction = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	# Функция, осуществляющая перемещение
	direction = move_and_slide(direction * speed)
