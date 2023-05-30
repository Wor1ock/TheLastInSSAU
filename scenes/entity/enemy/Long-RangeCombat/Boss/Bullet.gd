extends Area2D

const RIGHT = Vector2.RIGHT
export(int) var SPEED: int = 200
export(int) var damage: int = 1

func _physics_process(delta):
	var movement = RIGHT.rotated(rotation) * SPEED * delta
	global_position += movement

func take_damage(damage):
	print("ОТБИЛ")
	queue_free()

func _on_VisibilityNotifier2D_screen_exited():
	queue_free()

func _on_Bullet_area_entered(area):
	if area.has_method("hurtbox_take_damage"):
		area.hurtbox_take_damage(damage)
		queue_free()
