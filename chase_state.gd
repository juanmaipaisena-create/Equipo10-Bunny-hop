class_name EnemyChaseState
extends StateBase

func start():
	pass

func on_physics_process(delta):
	if controlled_node.player == null:
		return

	var direction = (
		controlled_node.player.global_position
		- controlled_node.global_position
	).normalized()

	# separación entre enemigos
	var separation = Vector2.ZERO

	for enemy in get_tree().get_nodes_in_group("Enemy"):
		if enemy == controlled_node:
			continue

		var distance = controlled_node.global_position.distance_to(
			enemy.global_position
		)

		if distance < 30:
			separation += (
				controlled_node.global_position
				- enemy.global_position
			).normalized()

	controlled_node.velocity = (
		(direction * controlled_node.velocidad)
		+ (separation * controlled_node.separation_force)
		+ controlled_node.knockback_velocity
	)

	controlled_node.move_and_slide()
	controlled_node.knockback_velocity *= controlled_node.knockback_resistance
	controlled_node.update_animation_by_direction(direction)

	# volver a idle si está lejos
	var distance_to_player = controlled_node.global_position.distance_to(
		controlled_node.player.global_position
	)
