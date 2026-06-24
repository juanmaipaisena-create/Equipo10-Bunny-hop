extends Node

@export var pesca_scene : PackedScene
@export var moneda_scene : PackedScene

var current_minigame = null
var reward_position := Vector2.ZERO

func start_fishing_minigame(position: Vector2):
	if current_minigame != null:
		return
	
	reward_position = position
	get_tree().paused = true
	current_minigame = pesca_scene.instantiate()
	get_tree().current_scene.add_child(current_minigame)
	current_minigame.minigame_completed.connect(
		_on_fishing_completed
	)

func _on_fishing_completed():
	print("MINIJUEGO TERMINADO")
	
	if current_minigame:
		current_minigame.queue_free()
		current_minigame = null
		
	get_tree().paused = false
	var player = get_tree().get_first_node_in_group("Player")
	
	if moneda_scene and player:
		var moneda = moneda_scene.instantiate()
		print('asigno moneda 1')
		print(moneda)
		get_tree().current_scene.add_child(moneda)
		print("Moneda agregada")
		moneda.global_position = reward_position
