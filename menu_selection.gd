extends Control

const Conejo_Scene= preload("res://Escenas/Personaje/conejo.tscn")
const Perro_Scene= preload("res://Escenas/Personaje/perro.tscn")
const Cerdo_Scene= preload("res://Escenas/Personaje/cerdo.tscn")
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_button_perro_pressed():
	Seleccion.personaje_seleccionado = Perro_Scene
	ir_al_juego()

func _on_button_conejo_pressed():
	Seleccion.personaje_seleccionado = Conejo_Scene
	ir_al_juego()

func _on_button_cerdo_pressed():
	Seleccion.personaje_seleccionado = Cerdo_Scene
	ir_al_juego()

func ir_al_juego():
	get_tree().change_scene_to_file("res://mundo.tscn")
