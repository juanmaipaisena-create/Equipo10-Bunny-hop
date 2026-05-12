class_name ConejoPlayer
extends CharacterBody2D

@export var bullet_scene: PackedScene
@export var shoot_cooldown := 0.3
var can_shoot := true

func _physics_process(delta: float) -> void:
	var direccion = Input.get_vector("ui_left","ui_right","ui_up","ui_down")
	velocity = direccion *230
	velocity.normalized()
	move_and_slide()

func _ready() -> void:
	$ConejoAnimatedSprite2D.play("Idle")

func _process(delta):
	if can_shoot:
		#_shoot()
		_auto_shoot()

#aparecen enemigos
#el conejo detecta el más cercano
#dispara automáticamente
func _shoot(target_position: Vector2):
	can_shoot = false
	var bullet = bullet_scene.instantiate()
	get_tree().current_scene.add_child(bullet)
	bullet.global_position = global_position
	var direction = (target_position - global_position).normalized()
	bullet.direction = direction
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
		return
	_shoot(enemy.global_position)
