extends Panel

signal upgrade_selected

@export var icon: CompressedTexture2D 
@export var description: String
@export var upgrade: PlayerStats.upgrades
@export var value : float = 0
@export var cost := 1

func _ready():
	$VBoxContainer/MarginContainer/TextureRect.texture = icon
	$VBoxContainer/MarginContainer2/Label.text = description + " Costo: " + str(cost)

func apply_upgrade():
	var player = get_tree().get_first_node_in_group("Player")
	if !PlayerStats.spend_coins(cost):
		print("No tienes suficientes monedas")
		$VBoxContainer/MarginContainer2/Label.text = "Monedas insuficientes"
		return
	PlayerStats.add_upgrade(
		upgrade,
		value,
		player
	)
	print("Mejora comprada por", cost, "monedas")
	upgrade_selected.emit()
