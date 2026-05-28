class_name Serpiente
extends CharacterBody2D

@onready var animation_snake = $SerpienteAnimatedSprite2D
@export var vida:int = 10
@export var velocidad:float = 150.0
@export var damage:int = 1
@export var health := 3
@export var knockback_resistance := 0.9
@export var separation_force := 40.0
@export var detection_radius := 200.0

var player: Node2D = null
var knockback_velocity := Vector2.ZERO

func _ready() -> void:
	var players = get_tree().get_nodes_in_group("Player")
	if players.size() > 0:
		player = players[0]
	else:
		print("No hay player en el grupo Player")

#func play_animation(state:String):
	#animation_snake.play(state + last_direction)
	
func play_animation(animation_name:String):
	animation_snake.play(animation_name)
		
func update_animation_by_direction(direction: Vector2):
	# horizontal
	if abs(direction.x) > abs(direction.y):
		animation_snake.play("WalkHorizontal")
		# flip sprite
		animation_snake.flip_h = direction.x < 0
	# vertical
	else:
		animation_snake.play("WalkVertical")
	
#func _physics_process(delta: float) -> void:
	#if player == null:
		#return
	#_movimiento()
	#animation()
#
#func _movimiento() -> void:
	#var direction = player.global_position - global_position
	#direction = direction.normalized()
	#var separation = Vector2.ZERO
	#for enemy in get_tree().get_nodes_in_group("Enemy"):
		#if enemy == self:
			#continue
		#var distance = global_position.distance_to(enemy.global_position)
		#if distance < 30:
			#separation += (global_position - enemy.global_position).normalized()
	#velocity = (direction * velocidad) + (separation * separation_force) + knockback_velocity
	#move_and_slide()
	#knockback_velocity *= knockback_resistance
#
#func animation():
	#animation_snake.play("Idle")

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
