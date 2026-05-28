class_name EnemyIdleState
extends StateBase

func start():
	controlled_node.animation_snake.play("Idle")

func on_physics_process(delta):
	if controlled_node.player == null:
		return

	var distance = controlled_node.global_position.distance_to(
		controlled_node.player.global_position
	)
	state_machine._change_to("chase_state")
