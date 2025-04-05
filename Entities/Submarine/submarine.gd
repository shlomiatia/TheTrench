class_name Submarine extends CharacterBody2D

const SPEED = 584.0
@onready var sprite_2d = $Sprite2D

func _physics_process(_delta: float) -> void:
	var direction = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	
	if direction.x != 0:
		if direction.x < 0:
			sprite_2d.scale = Vector2(1, 1)
		else:
			sprite_2d.scale = Vector2(-1, 1)
		
	if direction != Vector2.ZERO:
		velocity = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED / 10.0)
		velocity.y = move_toward(velocity.y, 0, SPEED / 10.0)
	
	move_and_slide()
