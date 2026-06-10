extends Node

@onready var panel = $CanvasLayer/Panel
@onready var pez = $CanvasLayer/Panel/pez
@onready var pez_sprite = $CanvasLayer/Panel/pez/saltopez
@onready var gato = $CanvasLayer/Panel/gato
@onready var gato_sprite = $CanvasLayer/Panel/gato/garragato
@onready var texto = $CanvasLayer/TextEdit
@export var max_game_time := 7.0

var game_started := false
var game_finished := false
var jump_timer : Timer
signal minigame_completed

func _ready():
	randomize()
	texto.text = "¡Prepárate!"
	# Ocultamos el pez al principio
	pez.hide()
	# Espera aleatoria entre 1 y 2 segundos
	var delay = randf_range(1.0, 2.0)
	await get_tree().create_timer(delay).timeout
	_start_game()
	pez_sprite.play("saltopez")
	gato_sprite.play("default")

func _move_fish():
	var x = randf_range(30, 220)
	var y = randf_range(30, 120)
	pez.position = Vector2(x, y)

func _input(event):
	if !game_started or game_finished:
		return
	if event is InputEventMouseButton and event.pressed:
		_check_fish_click()

func _check_fish_click():
	var mouse_pos = get_viewport().get_mouse_position()
	var fish_pos = pez_sprite.global_position
	if mouse_pos.distance_to(fish_pos) < 25:
		_fish_caught()
		
func _fish_caught():
	if game_finished:
		return
	game_finished = true
	pez.hide()
	texto.text = "¡PEZ ATRAPADO!"
	minigame_completed.emit()

func _start_game():
	game_started = true
	texto.text = "¡Atrápalo!"
	pez.show()
	_move_fish()
	# Tiempo máximo del minijuego
	await get_tree().create_timer(max_game_time).timeout
	if !game_finished:
		_game_over()

func _game_over():
	game_finished = true
	texto.text = "¡Tiempo agotado!"
	# Si quieres cerrar automáticamente después de 1 segundo:
	await get_tree().create_timer(1.0).timeout
	queue_free()
