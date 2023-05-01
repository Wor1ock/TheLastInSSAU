extends KinematicBody2D


signal health_updated(value)
signal max_health_updated(value)
signal damage_updated(value)
signal no_health()
signal died()


export(int) var speed := 300
export(int) var max_health := 10 setget _set_max_health
export(int) var health := max_health setget _set_health
export(int) var damage = 5 setget _set_damage


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
	health = clamp(value, 0, max_health)
	emit_signal("health_updated", health)
	if health <= 0:
		emit_signal("no_health")

# Изменение максимального здоровья
func _set_max_health(value):
	max_health = max(1, value)
	self.health = min(health, max_health)
	emit_signal("max_health_updated", max_health)

# Изменение наносимого урона
func _set_damage(value):
	damage = value
	emit_signal("damage_updated", damage)
