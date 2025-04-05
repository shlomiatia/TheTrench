class_name Submarine extends CharacterBody2D

@onready var sprite_2d = $Sprite2D

func _physics_process(delta: float) -> void:
	var direction = Input.get_vector("Left", "Right", "Up", "Down")
	
	if direction.x != 0:
		if direction.x < 0:
			sprite_2d.scale = Vector2(1, 1)
		else:
			sprite_2d.scale = Vector2(-1, 1)
		
	if direction != Vector2.ZERO:
		velocity = velocity.move_toward(direction * Constants.max_speed, delta * Constants.acceleration)
	else:
		velocity = velocity.move_toward(Vector2.ZERO, delta * Constants.deceleration)
	
	move_and_slide()
	$Label.text = "%s,%s=%s" % [floor(velocity.x), floor(velocity.y), floor(velocity.length())]
