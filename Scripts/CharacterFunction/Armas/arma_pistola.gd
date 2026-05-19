extends Area2D

#ignora player
#ignora paredes
#ignora tilemap
#apunta solo enemigos

@onready var animation_arm = $Marker2D/Pistola
@onready var shot_timer = $Timer

func _physics_process(delta):
	var enemies = get_tree().get_nodes_in_group("Enemy")

	if enemies.is_empty():
		return

	var nearest = null
	var min_dist = INF

	for e in enemies:
		if !is_instance_valid(e):
			continue

		var dist = global_position.distance_to(e.global_position)
		if dist < min_dist:
			min_dist = dist
			nearest = e
	if nearest:
		look_at(nearest.global_position)
	

func _ready():
	animation_arm.play("sprite_disparo")
	shot_timer.start()

func _on_timer_timeout():
	pass # Replace with function body.
