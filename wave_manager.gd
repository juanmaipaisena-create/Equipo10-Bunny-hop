class_name WaveManager
extends Node

@export var enemy_scene: PackedScene
@onready var spawn_points = $"./SpawnPoints".get_children()
#@onready var hud = $"../HUD"

@export var wave_time := 20.0
@export var max_waves := 10
@export var spawn_interval := 1.0

#testeamos con 3 y el release con 10
var wave := 3
var enemies_alive := 0
var current_wave := 0
var wave_active := false
var spawning := false
var spawn_timer := 0.0
var wave_timer := 0.0

func _ready():
	#Iniciar la primera horda
	start_wave()

func _process(delta):
	if not wave_active:
		return

	# countdown de la wave
	wave_timer -= delta
	
	# mientras se pueda spawnear
	if spawning:
		spawn_timer -= delta
		if spawn_timer <= 0:
			spawn_enemy()
			spawn_timer = spawn_interval
		# termina fase de spawn
		if wave_timer <= 0:
			spawning = false
			print("Fin de spawn")

func end_wave():
	wave_active = false
	print("Wave terminada:", current_wave)

	# dificultad progresiva
	spawn_interval = max(0.3, spawn_interval * 0.9)
	await get_tree().create_timer(2.0).timeout
	start_wave()

#Iniciar la primera horda
func start_wave():
	if current_wave >= max_waves:
		print("Juego terminado")
		return

	current_wave += 1
	wave_active = true
	spawning = true

	wave_timer = wave_time
	spawn_timer = 0.5
	print("Wave:", current_wave)

#Spawnear enemigo
func spawn_enemy():
	if spawn_points.is_empty():
		return

	var spawner = spawn_points.pick_random()
	var enemy = enemy_scene.instantiate()
	get_tree().current_scene.add_child(enemy)
	enemy.global_position = spawner.global_position
	enemies_alive += 1
	# conexión automática
	enemy.tree_exited.connect(_on_enemy_died)

#Detectar cuando mueren
func _on_enemy_died():
	enemies_alive -= 1
	print("Enemigos vivos:", enemies_alive)

	# si terminó el spawn Y no quedan enemigos
	if not spawning and enemies_alive <= 0:
		end_wave()

#Siguiente wave
func next_wave():
	wave += 1
	if !is_inside_tree():
		return
	await get_tree().create_timer(2.0).timeout
	if !is_inside_tree():
		return
	start_wave()
