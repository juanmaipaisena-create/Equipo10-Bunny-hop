class_name Serpiente
extends CharacterBody2D


@export var vida:int = 10
@export var velocidad:int = 1
@export var damage:int = 1

#var player: ConejoPlayer = null
var player: Node2D = null

func _ready() -> void:
	#player = get_tree().get_nodes_in_group("Player")[0]
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
	var direccion: Vector2 = player.global_position - global_position
	velocity = direccion.normalized() * velocidad
	move_and_slide()
