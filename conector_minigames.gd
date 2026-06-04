extends Node

@export var pesca_scene : PackedScene

var current_minigame = null

func start_fishing_minigame():
	if current_minigame != null:
		return
	get_tree().paused = true
	current_minigame = pesca_scene.instantiate()
	get_tree().current_scene.add_child(current_minigame)
	current_minigame.minigame_completed.connect(
		_on_fishing_completed
	)

func _on_fishing_completed():
	if current_minigame:
		current_minigame.queue_free()
		current_minigame = null
		get_tree().paused = false

#esto es un hack para probar el mini juego, lo descomentas y le das a space o enter, se activa y podes testearlo
#func _input(event):
	#if event.is_action_pressed("ui_accept"):
		#start_fishing_minigame()
