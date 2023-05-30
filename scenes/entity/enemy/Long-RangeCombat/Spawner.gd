extends "res://scenes/entity/enemy/CloseCombat/CloseCombat.gd"


export var mini_enemy: PackedScene

func _physics_process(delta):
	engage(player)

# Функция для спавна 2 маленьких мобов
func spawn (): 
	var inst1= mini_enemy.instance()
	var inst2= mini_enemy.instance()
	var tl=get_node("..")
	tl.add_child(inst1)
	tl.add_child(inst2)
	inst1.transform=$Position2D3.global_transform
	inst2.transform=$Position2D2.global_transform


func _on_Spawner_died():
	spawn()
