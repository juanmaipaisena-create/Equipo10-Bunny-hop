extends Node2D

signal arcade_collected


func _on_area_2d_body_entered(body: Node2D) -> void:
	if !body.is_in_group("Player"):
		return
	var connector = get_tree().get_first_node_in_group(
		"MinigameConnector"
	)
	if connector:
		connector.start_fishing_minigame()
	queue_free()

func _ready():
	$AnimatedSprite2D.play("Arcade")
