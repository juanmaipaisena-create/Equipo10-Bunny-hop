extends Panel

signal upgrade_selected

@export var icon: CompressedTexture2D 
@export var description: String
@export var upgrade: PlayerStats.upgrades
@export var value : float = 0
@export var cost := 1

func _ready():
	$VBoxContainer/MarginContainer/TextureRect.texture = icon
	$VBoxContainer/MarginContainer2/Label.text = description

func apply_upgrade():
	#Buscamos al conejo en la escena activa
	var player = get_tree().get_first_node_in_group("Player")
	
	if PlayerStats.coins < cost:
		print("No tienes suficientes monedas")
		return
	PlayerStats.coins -= cost
	PlayerStats.add_upgrade(
		upgrade,
		value,
		player
	)
	upgrade_selected.emit()
