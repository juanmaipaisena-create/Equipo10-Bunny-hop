class_name WaveManagerViejo
extends Node

@export var enemy_scene: PackedScene #serpiente
@export var miniboss_scene: PackedScene #arana
@onready var spawn_points = $"./SpawnPoints".get_children()
@onready var hud = $"../CanvasLayer/HUD"

@export var wave_time := 20.0
@export var max_waves := 10
@export var spawn_interval := 1.0
@export var miniboss_spawn_time := 10.0#60.0 #arana
var miniboss_spawned_waves: Array[int] = []
const MINIBOSS_WAVES = [1, 3, 5, 7, 9]

#testeamos con 3 y el release con 10
var wave := 10
var enemies_alive := 0
var current_wave := 0
var wave_active := false
var spawning := false
var spawn_timer := 0.0
var wave_timer := 0.0
var miniboss_timer := 10.0#60.0 #arana

func _ready():
	#Iniciar la primera horda
	await get_tree().process_frame #espera un frame antes de iniciar wave
	start_wave()

func _process(delta):
		
	if not wave_active:
		return

	wave_timer -= delta
	hud.update_time(wave_timer)
	hud.update_enemies(enemies_alive)

	if spawning:
		spawn_timer -= delta
		if spawn_timer <= 0:
			spawn_enemy()
			spawn_timer = spawn_interval
		if wave_timer <= 0:
			spawning = false

func _spawn_miniboss():
	if miniboss_scene == null:
		print("MINIBOSS SCENE NO ASIGNADA")
		return
		
	if spawn_points.is_empty():
		return

	var spawner = spawn_points.pick_random()
	var miniboss = miniboss_scene.instantiate()
	get_tree().current_scene.add_child(miniboss)
	miniboss.global_position = spawner.global_position
	enemies_alive += 1
	miniboss.enemy_died.connect(_on_enemy_died)
	print("MINIBOSS SPAWN")
	
func end_wave():
	if not is_inside_tree():
		return

	wave_active = false
	print("Wave terminada:", current_wave)
	spawn_interval = max(0.3, spawn_interval * 0.9)
	var tree = get_tree()

	if tree == null:
		return

	await tree.create_timer(2.0).timeout
	start_wave()

#Iniciar la primera horda
func start_wave():
	if current_wave >= max_waves:
		print("Juego terminado")
		return

	current_wave += 1
	print("=== INICIANDO WAVE:", current_wave, "===")
	wave_active = true
	spawning = true
	wave_timer = wave_time
	spawn_timer = 0.5

	# Reinicia el temporizador de miniboss al comenzar la ronda
	miniboss_timer = miniboss_spawn_time
	
	hud.update_wave(current_wave)
	print("Wave:", current_wave)
	if current_wave % 2 == 1:
		print("Generando araña en wave", current_wave)
		_spawn_miniboss()

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
	enemy.enemy_died.connect(_on_enemy_died)

#Detectar cuando mueren
func _on_enemy_died():
	enemies_alive = max(0, enemies_alive - 1)
	print(
		"Wave:",
		current_wave,
		" Enemigos vivos:",
		enemies_alive,
		" Spawning:",
		spawning
	)
	hud.update_enemies(enemies_alive)
	if not spawning and enemies_alive == 0:
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
