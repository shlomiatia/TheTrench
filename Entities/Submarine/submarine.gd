class_name Submarine extends CharacterBody2D

@onready var sprite_2d: Sprite2D = $Sprite2D
@onready var canvas_modulate: CanvasModulate = $/root/Game/CanvasModulate
@onready var beam_light_2d: PointLight2D = $Sprite2D/BeamLight2D
@onready var point_light_2d: PointLight2D = $PointLight2D

func _physics_process(delta: float) -> void:
    var direction = Input.get_vector("Left", "Right", "Up", "Down")
	
    if direction.x != 0:
        if direction.x < 0:
            sprite_2d.scale = Vector2(-1, 1)
        else:
            sprite_2d.scale = Vector2(1, 1)
		
    velocity = Vector2(get_velocity_component(direction.x, velocity.x, delta), get_velocity_component(direction.y, velocity.y, delta))
	
    move_and_slide()
    #$Label.text = "%s,%s=%s" % [floor(velocity.x), floor(velocity.y), floor(velocity.length())]
    
    var darkness = clampf(lerpf(0.0, 1.0, (position.y - Constants.twilight_start) / (Constants.twilight_end - Constants.twilight_start)), 0.0, 1.0)
    var color_component = 1.0 - darkness
    canvas_modulate.color = Color(color_component, color_component, color_component, 1.0)
    beam_light_2d.energy = darkness
    point_light_2d.energy = darkness

    $Label.text = "%s,%s" % [floor(position.y), canvas_modulate.color.r]

func get_velocity_component(direction: float, velocity_component: float, delta: float):
    if (velocity_component <= 0.0 && direction < 0.0 || velocity_component >= 0.0 && direction > 0.0):
        return move_toward(velocity_component, direction * Constants.max_speed, delta * Constants.acceleration)
    return move_toward(velocity_component, 0.0, delta * Constants.deceleration)