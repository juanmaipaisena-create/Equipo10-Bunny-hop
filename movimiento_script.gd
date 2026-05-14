class_name ConejoPlayer
extends CharacterBody2D

@onready var animated_sprite = $ConejoAnimatedSprite2D
@export var bullet_scene: PackedScene
@export var shoot_cooldown := 0.3
var can_shoot := true
var last_direction := "Down"
var health := 10
var invincible := false

func _physics_process(delta: float) -> void:
	get_input()
	move_and_slide()
	var limite_izq = 0
	var limite_der = 864
	var limite_sup = 0
	var limite_inf = 480
	global_position.x = clamp(global_position.x, limite_izq, limite_der)
	global_position.y = clamp(global_position.y, limite_sup, limite_inf)

func get_input():
	var direccion = Input.get_vector("ui_left","ui_right","ui_up","ui_down")
	
	if direccion == Vector2.ZERO:
		velocity = Vector2.ZERO
		update_animation("Idle")
		return
	
	if abs(direccion.x) > abs (direccion.y):
		if direccion.x > 0:
			last_direction = "Right"
		else:
			last_direction = "Left"
	else:
		if direccion.y > 0:
			last_direction = "Down"
		else:
			last_direction = "Up"
	update_animation("Run")
	velocity = direccion.normalized() * 230

func update_animation(state):
	animated_sprite.play(state + last_direction)
#func _ready() -> void:
#	$ConejoAnimatedSprite2D.play("Idle")

func _process(delta):
	if can_shoot:
		can_shoot = false
		_auto_shoot()

#aparecen enemigos
#el conejo detecta el más cercano
#dispara automáticamente
func _shoot(target_position: Vector2):
	can_shoot = false
	var bullet = bullet_scene.instantiate()
	get_tree().current_scene.add_child(bullet)
	#bullet.global_position = global_position
	var direction = (target_position - global_position).normalized()
	bullet.direction = direction
	bullet.global_position = global_position + (direction * 30)
	await get_tree().create_timer(shoot_cooldown).timeout
	can_shoot = true
	
#obtiene todos los enemigos
#compara distancias
#devuelve el más cercano
func _get_nearest_enemy():
	var enemies = get_tree().get_nodes_in_group("Enemy")
	
	if enemies.is_empty():
		return null
	
	var nearest = enemies[0]
	var nearest_distance = global_position.distance_to(nearest.global_position)
	
	for enemy in enemies:
		var distance = global_position.distance_to(enemy.global_position)
		if distance < nearest_distance:
			nearest = enemy
			nearest_distance = distance
	return nearest
	
func _auto_shoot():
	var enemy = _get_nearest_enemy()
	if enemy == null:
		can_shoot = true
		return
	_shoot(enemy.global_position)
# --------------------------
# VIDA / DAÑO
# --------------------------
func take_damage(amount: int) -> void:
	if invincible:
		return

	health -= amount
	print("Vida:", health)

	hit_feedback()

	if health <= 0:
		die()

func hit_feedback() -> void:
	var tween = create_tween()
	tween.tween_property(self, "scale", Vector2(1.15, 1.15), 0.05)
	tween.tween_property(self, "scale", Vector2(1, 1), 0.05)

	start_invincibility()

func start_invincibility() -> void:
	invincible = true
	modulate = Color(1, 0.4, 0.4)

	await get_tree().create_timer(1.0).timeout

	modulate = Color(1, 1, 1)
	invincible = false

func die() -> void:
	print("Game Over")
	call_deferred("_die_deferred")
	
func _die_deferred():
	queue_free()
