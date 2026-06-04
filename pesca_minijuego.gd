extends Node

@onready var panel = $CanvasLayer/Panel
@onready var pez = $CanvasLayer/Panel/pez
@onready var pez_sprite = $CanvasLayer/Panel/pez/saltopez
@onready var gato = $CanvasLayer/Panel/gato
@onready var gato_sprite = $CanvasLayer/Panel/gato/garragato
@onready var texto = $CanvasLayer/TextEdit

var jump_timer : Timer
var game_finished := false
signal minigame_completed

func _ready():
	randomize()
	texto.text = "ATRAPA AL PEZ"
	jump_timer = Timer.new()
	jump_timer.wait_time = 1.0
	jump_timer.autostart = true
	jump_timer.timeout.connect(_move_fish)
	add_child(jump_timer)
	pez_sprite.play("saltopez")
	gato_sprite.play("default")

func _move_fish():
	var x = randf_range(30, 220)
	var y = randf_range(30, 120)
	pez.position = Vector2(x, y)

func _input(event):
	if game_finished:
		return
	if event is InputEventMouseButton:
		if event.pressed:
			_check_fish_click()

func _check_fish_click():
	var mouse_pos = get_viewport().get_mouse_position()
	var fish_pos = pez_sprite.global_position
	if mouse_pos.distance_to(fish_pos) < 25:
		_fish_caught()
		
func _fish_caught():
	game_finished = true
	jump_timer.stop()
	pez.hide()
	texto.text = "¡PEZ ATRAPADO!"
	minigame_completed.emit()
