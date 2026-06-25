extends Control

@onready var upgrade_card_container = $HBoxContainer
@onready var skip_button = $SkipButton

func _ready():
	#print("Hijos de Control:")
	#for child in get_children():
		#print(child.name)

	get_tree().paused = true
	for node in upgrade_card_container.get_children():
		node.upgrade_selected.connect(_quit)
	skip_button.text = "Guardar " + str(PlayerStats.coins) + " monedas"
	skip_button.pressed.connect(_quit)
	
func _input(event):
	var mousePosition = get_global_mouse_position()
	
	if event is InputEventMouseButton && event.button_index == 1 && event.is_pressed(): 
		for node in upgrade_card_container.get_children():
			if node.get_global_rect().has_point(mousePosition):
				node.apply_upgrade()
		
func _quit():
	get_tree().paused = false
	queue_free()
