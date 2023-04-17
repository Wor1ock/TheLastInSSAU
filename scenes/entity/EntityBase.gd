extends KinematicBody2D


signal health_updated(health)
signal no_health()
signal died()


export(int) var speed := 300
export(int) var max_health := 10
export(int) var health := max_health setget _set_health
export(int) var damage = 5


var velocity := Vector2.ZERO

# Передвижение сущности
func move():
	velocity = move_and_slide(velocity)

# Получение урона
func take_damage(amount):
	# _set_health(health - amount)
	self.health -= amount

# Вызывается при смерти персонажа
func die():
	emit_signal("died")
	queue_free()

# Изменение здоровья
func _set_health(value):
	var prev_health := health
	health = clamp(value, 0, max_health)
	if health != prev_health:
		emit_signal("health_updated", health)
	if health <= 0:
		emit_signal("no_health")
