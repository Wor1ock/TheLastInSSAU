extends Area2D


onready var collisionShape = $CollisionShape2D


func hurtbox_take_damage(damage):
	get_parent().take_damage(damage)

# Настройка неуязвимости
func set_invulnerability(is_invulnerable: bool):
	collisionShape.disabled = is_invulnerable
