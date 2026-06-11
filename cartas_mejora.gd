extends Panel

signal upgrade_selected

@export var icon: CompressedTexture2D 
@export var description: String
@export var upgrade: PlayerStats.upgrades

func _ready():
	$VBoxContainer/MarginContainer/TextureRect.texture = icon
	$VBoxContainer/MarginContainer2/Label.text = description

func apply_upgrade():
	var upgradeNumber = int(description.split(" ")[0].replace("+","").replace("%",""))
	
	# 1. Buscamos al conejo en la escena activa
	var player = get_tree().get_first_node_in_group("Player")
	
	# 2. Le pasamos las 3 cosas a PlayerStats (tipo, cantidad, y el nodo del jugador)
	PlayerStats.add_upgrade(upgrade, upgradeNumber, player)
	
	upgrade_selected.emit()
