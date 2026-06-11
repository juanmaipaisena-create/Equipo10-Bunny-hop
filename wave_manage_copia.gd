class_name WaveManager
extends Node

@export var enemy_scene: PackedScene #serpiente
@export var miniboss_scene: PackedScene #arana
@onready var spawn_points = $"./SpawnPoints".get_children()
@onready var hud = $"../CanvasLayer/HUD"

# === NUEVAS EXPORTACIONES PARA LA TIENDA FÍSICA ===
@onready var tienda_area: Area2D = $"../tienda"
@export var escena_mejoras: String = "res://cartas_verdadero.tscn"
# ====================================================

@export var wave_time := 20.0
@export var max_waves := 10
@export var spawn_interval := 1.0
@export var miniboss_spawn_time := 10.0 #arana
var miniboss_spawned_waves: Array[int] = []
const MINIBOSS_WAVES = [1, 3, 5, 7, 9]

var wave := 10
var enemies_alive := 0
var current_wave := 0
var wave_active := false
var spawning := false
var spawn_timer := 0.0
var wave_timer := 0.0
var miniboss_timer := 10.0

func _ready():
	# Nos aseguramos de que la tienda empiece oculta y desactivada
	if tienda_area:
		tienda_area.visible = false
		tienda_area.monitoring = false
		# Conectamos la señal de que algo entró a la tienda
		tienda_area.body_entered.connect(_on_tienda_body_entered)
		
	# Iniciar la primera horda
	await get_tree().process_frame
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
	
# === FUNCIÓN END_WAVE MODIFICADA ===
func end_wave():
	if not is_inside_tree():
		return

	wave_active = false
	print("Wave terminada:", current_wave)
	spawn_interval = max(0.3, spawn_interval * 0.9)
	var tree = get_tree()

	if tree == null:
		return

	# Comprobamos si la ronda que terminó es la 1, 3, 5 o 7
	if current_wave in [1, 3, 5, 7] and tienda_area:
		print("¡La tienda ha aparecido en el mapa por 10 segundos!")
		
		# Opcional: Aquí puedes cambiar la posición de la tienda a una aleatoria o al centro
		# tienda_area.global_position = Vector2(500, 400) 
		
		tienda_area.visible = true
		tienda_area.monitoring = true # Activa las colisiones de la tienda
		
		# Esperamos los 10 segundos
		await tree.create_timer(10.0).timeout
		
		# Si pasaron los 10 segundos y sigue visible (el jugador no entró)
		if tienda_area.visible: 
			print("La tienda se desvaneció. Siguiente ronda.")
			tienda_area.visible = false
			tienda_area.monitoring = false
			
			await tree.create_timer(1.0).timeout
			start_wave()
			return

	# Si es una ronda normal, continúa sin mostrar la tienda
	await tree.create_timer(2.0).timeout
	start_wave()

# === CUANDO EL PERSONAJE ENTRA EN CONTACTO CON LA TIENDA ===
func _on_tienda_body_entered(body):
	# Idealmente verificamos que el cuerpo que entró sea el jugador
	# Puedes verificarlo por su nombre, su grupo o su script/clase. Ej: if body.is_in_group("Player"):
	print(body.name, " entró a la tienda.")
	
	# Desactivamos la tienda inmediatamente para evitar múltiples detecciones
	tienda_area.visible = false
	tienda_area.monitoring = false
	
	# Pausamos el juego y nos vamos a las cartas
	get_tree().paused = true 
	get_tree().change_scene_to_file(escena_mejoras)

# Iniciar la primera horda
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

	miniboss_timer = miniboss_spawn_time
	
	hud.update_wave(current_wave)
	print("Wave:", current_wave)
	if current_wave % 2 == 1:
		print("Generando araña en wave", current_wave)
		_spawn_miniboss()

# Spawnear enemigo
func spawn_enemy():
	if spawn_points.is_empty():
		return

	var spawner = spawn_points.pick_random()
	var enemy = enemy_scene.instantiate()
	get_tree().current_scene.add_child(enemy)
	enemy.global_position = spawner.global_position
	enemies_alive += 1
	enemy.enemy_died.connect(_on_enemy_died)

# Detectar cuando mueren
func _on_enemy_died():
	enemies_alive = max(0, enemies_alive - 1)
	hud.update_enemies(enemies_alive)
	if not spawning and enemies_alive == 0:
		end_wave()

# Siguiente wave
func next_wave():
	wave += 1
	if !is_inside_tree():
		return
	await get_tree().create_timer(2.0).timeout
	if !is_inside_tree():
		return
	start_wave()
