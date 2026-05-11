extends Node

@export var enemy_scene: PackedScene
@onready var spawn_points = $"./SpawnPoints".get_children()

var wave := 5
var enemies_alive := 0

func _ready():
	#Iniciar la primera horda
	start_wave()

#Iniciar la primera horda
func start_wave():
	var cantidad = wave * 3
	enemies_alive = cantidad
	
	for i in cantidad:
		spawn_enemy()
		await get_tree().create_timer(0.5).timeout

#Spawnear enemigo
func spawn_enemy():
	var enemy = enemy_scene.instantiate()
	var spawn = spawn_points[randi() % spawn_points.size()]
	enemy.global_position = spawn.global_position
	add_child(enemy)
	
	#conectar muerte
	enemy.tree_exited.connect(_on_enemy_died)

#Detectar cuando mueren
func _on_enemy_died():
	enemies_alive -= 1
	
	if enemies_alive <= 0:
		next_wave()

#Siguiente wave
func next_wave():
	wave += 1
	if !is_inside_tree():
		return
	await get_tree().create_timer(2.0).timeout
	if !is_inside_tree():
		return
	start_wave()
