class_name Serpiente
extends CharacterBody2D

@export var vida:int = 10
@export var velocidad:int = 1
@export var damage:int = 1

var player: ConejoPlayer = null
	
func _ready() -> void:
	player = get_tree().get_nodes_in_group("Player")[0]
	
func _physics_process(delta: float) -> void:
	_movimiento()

func _movimiento() -> void:
	var direccion: Vector2 = player.global_position - global_position
	#print("player.global_position")
	#print(player.global_position)
	#print("global_position")
	#print(global_position)
	#velocity.normalized()
	velocity = direccion.normalized() * velocidad
	move_and_slide()
