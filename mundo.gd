extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready():
	if Seleccion.personaje_seleccionado:
		var jugador = Seleccion.personaje_seleccionado.instantiate()
		jugador.global_position = Vector2 (431, 239)
		add_child(jugador)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
