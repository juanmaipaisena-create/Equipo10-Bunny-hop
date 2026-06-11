class_name IdleState
extends StateBase

func start():
	controlled_node.velocity = Vector2.ZERO
	controlled_node.play_animation("Idle")

func on_physics_process(delta):
	var direction = Input.get_vector(
		"izquierda",
		"derecha",
		"arriba",
		"abajo"
	)
	if direction != Vector2.ZERO:
		state_machine._change_to("move_state")
