extends Area2D
@export var damage := 1
@export var cooldown := 1.0

var can_damage := true


func _ready() -> void:
	body_entered.connect(_on_body_entered)


func _on_body_entered(body: Node) -> void:
	if not can_damage:
		return

	if body.is_in_group("Player"):
		if body.has_method("take_damage"):
			body.take_damage(damage)
			var push_direction = (body.global_position - global_position).normalized()
			body.apply_knockback(push_direction * 250)
		_start_cooldown()


func _start_cooldown() -> void:
	if not is_inside_tree():
		return
	can_damage = false
	var t = get_tree().create_timer(cooldown)
	await t.timeout
	if not is_inside_tree():
		return
	can_damage = true
