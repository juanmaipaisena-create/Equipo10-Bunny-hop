extends CharacterBody2D

func _physics_process(delta: float) -> void:
	var direccion = Input.get_vector("ui_left","ui_right","ui_up","ui_down")
	velocity = direccion *230
	move_and_slide()

func _ready() -> void:
	$ConejoAnimatedSprite2D.play("Idle")
