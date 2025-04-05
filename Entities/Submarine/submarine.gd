class_name Submarine extends CharacterBody2D

@onready var sprite_2d: Sprite2D = $Sprite2D
@onready var canvas_modulate: CanvasModulate = $/root/Game/CanvasModulate
@onready var beam_light_2d: PointLight2D = $Sprite2D/BeamLight2D
@onready var point_light_2d: PointLight2D = $PointLight2D
var is_diving = false

func _physics_process(delta: float) -> void:
    var direction := Input.get_vector("Left", "Right", "Up", "Down")
    if direction.y > 0:
        is_diving = true

    if global_position.x < 400:
        direction = Vector2(1.0, direction.y).normalized()
        velocity.x = Constants.max_speed
    elif global_position.x > 20000:
        direction = Vector2(-1.0, direction.y).normalized()
        velocity.x = - Constants.max_speed

    if !is_diving && global_position.y == 0 && direction.y <= 0.0:
         direction = Vector2(direction.x, 0.0)
         velocity = Vector2(get_velocity_component(direction.x, velocity.x, delta), velocity.y)
         if velocity.x > 0.0:
            rotation = 0.0
            scale = Vector2(1.0, 1.0)
         elif velocity.x < 0.0:
            rotation = - PI
            scale = Vector2(1.0, -1.0)
    elif global_position.y < 0.0:
        direction = Vector2(direction.x, 0.0)
        velocity = Vector2(get_velocity_component(direction.x, velocity.x, delta), velocity.y)
        velocity += get_gravity() * delta
    else:
        velocity = Vector2(get_velocity_component(direction.x, velocity.x, delta), get_velocity_component(direction.y, velocity.y, delta))

    if is_diving:
        hande_rotation_and_scale(direction, delta)

    move_and_slide()
    handle_light()
    
    $Label.text = "%s" % [floor(global_position.x)]

func hande_rotation_and_scale(direction: Vector2, delta: float) -> void:
    if (global_position.y == 0.0):
        return
    if direction == Vector2.ZERO:
        return
    var target_angle = direction.angle()
    var current_angle = rotation
    
    var angle_diff = wrapf(target_angle - current_angle, -PI, PI)
    var max_rotation = deg_to_rad(Constants.rotation_speed) * delta
    if abs(angle_diff) <= max_rotation:
        rotation = target_angle
    else:
        rotation += max_rotation * sign(angle_diff)

    if absf(rotation_degrees) != 90.0:
        if rotation_degrees > -90 and rotation_degrees < 90:
            scale = Vector2(1.0, abs(scale.y))
        else:
            scale = Vector2(1.0, -abs(scale.y))

func handle_light() -> void:
    var darkness = clampf(lerpf(0.0, 1.0, (position.y - Constants.twilight_start) / (Constants.twilight_end - Constants.twilight_start)), 0.0, 1.0)
    var color_component = 1.0 - darkness
    canvas_modulate.color = Color(color_component, color_component, color_component, 1.0)
    beam_light_2d.energy = darkness
    point_light_2d.energy = darkness
    
func get_velocity_component(direction: float, velocity_component: float, delta: float):
    if (velocity_component <= 0.0 && direction < 0.0 || velocity_component >= 0.0 && direction > 0.0):
        return move_toward(velocity_component, direction * Constants.max_speed, delta * Constants.acceleration)
    return move_toward(velocity_component, 0.0, delta * Constants.deceleration)
