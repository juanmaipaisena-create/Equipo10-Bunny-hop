extends Panel

signal upgrade_selected

@export var icon: CompressedTexture2D 
@export var description: String
@export var upgrade: PlayerStats.upgrades
@export var value : float = 0

func _ready():
	$VBoxContainer/MarginContainer/TextureRect.texture = icon
	$VBoxContainer/MarginContainer2/Label.text = description

func apply_upgrade():
	#Buscamos al conejo en la escena activa
	var player = get_tree().get_first_node_in_group("Player")
	
	#Le pasamos las 3 cosas a PlayerStats (tipo, cantidad, y el nodo del jugador)
	PlayerStats.add_upgrade(
		upgrade,
		value,
		player
	)
	
	upgrade_selected.emit()
