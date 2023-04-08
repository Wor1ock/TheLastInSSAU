extends Area2D


func hurtbox_take_damage(damage):
	get_parent().take_damage(damage)
#	get_tree().take_damage(damage)
