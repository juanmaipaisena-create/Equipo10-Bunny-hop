extends Area2D


func _physics_process(delta):
	var enemigo_en_rango = get_overlapping_bodies()
	if enemigo_en_rango.size() > 0:
		var enemigo_apuntado = enemigo_en_rango[0]
		look_at(enemigo_apuntado.global_position)
		
