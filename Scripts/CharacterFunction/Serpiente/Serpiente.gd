class_name Serpiente
extends CharacterBody2D

@export var vida:int = 10
@export var velocidad:float = 80.0
@export var damage:int = 1
@export var health := 3
@export var knockback_resistance := 0.9
@export var separation_force := 40.0

var player: Node2D = null
var knockback_velocity := Vector2.ZERO

func _ready() -> void:
	var players = get_tree().get_nodes_in_group("Player")
	if players.size() > 0:
		player = players[0]
	else:
		print("No hay player en el grupo Player")
	
func _physics_process(delta: float) -> void:
	if player == null:
		return
	_movimiento()

func _movimiento() -> void:
	var direction = player.global_position - global_position
	direction = direction.normalized()
	var separation = Vector2.ZERO
	for enemy in get_tree().get_nodes_in_group("Enemy"):
		if enemy == self:
			continue
		var distance = global_position.distance_to(enemy.global_position)
		if distance < 30:
			separation += (global_position - enemy.global_position).normalized()
	velocity = (direction * velocidad) + (separation * separation_force) + knockback_velocity
	move_and_slide()
	knockback_velocity *= knockback_resistance
	
func take_damage(amount):
	health -= amount
	if health <= 0:
		die()

signal enemy_died

func die():
	enemy_died.emit()
	queue_free()

func apply_knockback(force: Vector2):
	knockback_velocity += force


#func _on_hitbox_body_entered(body: Node2D) -> void:
	#if body.is_in_group("Player"):
		#body.take_damage(1)
