class_name Submarine extends CharacterBody2D

@onready var sprite_2d: Sprite2D = $Sprite2D
@onready var canvas_modulate: CanvasModulate = $/root/Game/CanvasModulate
@onready var beam_light_2d: PointLight2D = $Sprite2D/BeamLight2D
@onready var point_light_2d: PointLight2D = $PointLight2D
@onready var audio_stream_player: AudioStreamPlayer = $AudioStreamPlayer
@onready var dialog: Dialog = $/root/Game/CanvasLayer/Dialog

var is_diving = false
var can_move = true
var is_trapped = false

func _physics_process(delta: float) -> void:
    if !can_move:
        return
    var direction := Input.get_vector("Left", "Right", "Up", "Down")

    handle_dive_start(direction)
    direction = handle_collision(direction)
    direction = handle_out_of_bounds(direction)

    if !is_diving && global_position.y == 0 && direction.y <= 0.0:
        direction = handle_surface_movement(direction, delta)
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

func handle_dive_start(direction: Vector2) -> void:
    if direction.y > 0 && !is_diving:
        is_diving = true
        audio_stream_player.stream = preload("res://Sounds/water.wav")
        audio_stream_player.play()

func handle_collision(direction: Vector2) -> Vector2:
    if is_on_floor():
        direction = get_floor_normal()
        velocity = direction * Constants.max_speed
        if !audio_stream_player.playing:
            audio_stream_player.stream = preload("res://Sounds/hit.wav")
            audio_stream_player.play()
    return direction

func handle_out_of_bounds(direction: Vector2) -> Vector2:
    if global_position.x < Constants.left_play_area:
        direction = Vector2(1.0, direction.y).normalized()
        velocity.x = Constants.max_speed
        if !dialog.is_playing:
            dialog.display_text("The trench is on the other side")
    elif global_position.x > Constants.right_play_area:
        direction = Vector2(-1.0, direction.y).normalized()
        velocity.x = - Constants.max_speed
        if !dialog.is_playing:
            dialog.display_text("The trench is on the other side")
    elif is_trapped && global_position.y < 43650:
        direction = Vector2(direction.x, 1.0).normalized()
        velocity.y = Constants.max_speed
        if !dialog.is_playing:
            dialog.display_text("I can't get out!")
    return direction

func handle_surface_movement(direction: Vector2, delta: float) -> Vector2:
    direction = Vector2(direction.x, 0.0)
    velocity = Vector2(get_velocity_component(direction.x, velocity.x, delta), velocity.y)
    if velocity.x > 0.0:
        rotation = 0.0
        scale = Vector2(1.0, 1.0)
    elif velocity.x < 0.0:
        rotation = - PI
        scale = Vector2(1.0, -1.0)
    return direction

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
