extends Area2D

@export var value := 1

func _ready():
	body_entered.connect(_on_body_entered)
	$moneda.play()

func _on_body_entered(body):
	if !body.is_in_group("Player"):
		return
	PlayerStats.add_coin(value)
	queue_free()
