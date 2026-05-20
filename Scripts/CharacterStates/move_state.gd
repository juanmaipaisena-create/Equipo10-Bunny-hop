class_name MoveState
extends StateBase

func start():
	controlled_node.play_animation("Run")

func on_physics_process(delta):
	var direction = Input.get_vector(
		"ui_left",
		"ui_right",
		"ui_up",
		"ui_down"
	)
	if direction == Vector2.ZERO:
		state_machine._change_to("idle_state")
		return

	_update_direction(direction)
	controlled_node.velocity = (
		direction.normalized()
		* controlled_node.speed
	) + controlled_node.knockback_velocity

func _update_direction(direction):
	if abs(direction.x) > abs(direction.y):
		if direction.x > 0:
			controlled_node.last_direction = "Right"
		else:
			controlled_node.last_direction = "Left"
	else:
		if direction.y > 0:
			controlled_node.last_direction = "Down"
		else:
			controlled_node.last_direction = "Up"
			
	controlled_node.play_animation("Run")
