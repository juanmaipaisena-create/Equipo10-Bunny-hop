extends Area2D

@export var speed := 500.0
@export var life_time := 2.0
var direction := Vector2.RIGHT

#func _process(delta):
	#position += direction * speed * delta
	
func _physics_process(delta):
	position += direction * speed * delta

#las serpientes son empujadas y se siente mas mejor
func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("Enemy"):
		body.take_damage(1)
		var knockback_force = direction * 250
		body.apply_knockback(knockback_force)
		queue_free()

#desaparecen balas
#no llenan memoria
#mejora de rendimiento
func _ready():
	await get_tree().create_timer(life_time).timeout
	queue_free()
