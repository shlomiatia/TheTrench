class_name Submarine extends CharacterBody2D

@onready var sprite_2d: Sprite2D = $Sprite2D
@onready var canvas_modulate: CanvasModulate = $/root/Game/CanvasModulate
@onready var beam_light_2d: PointLight2D = $Sprite2D/BeamLight2D
@onready var point_light_2d: PointLight2D = $PointLight2D
@onready var audio_stream_player: AudioStreamPlayer = $AudioStreamPlayer
@onready var dialog: Dialog = $/root/Game/CanvasLayer/Dialog
@onready var animated_sprite_2d: AnimatedSprite2D = $Sprite2D/AnimatedSprite2D
@onready var cpu_particles_2d: CPUParticles2D = $CPUParticles2D
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var camera_2d: Camera2D = $Camera2D

var is_diving: bool = false
var can_move: bool = false
var is_trapped: bool = false

func _physics_process(delta: float) -> void:
    print(sprite_2d.position)
    if !is_diving:
        sprite_2d.material.set_shader_parameter("y_threshold", (15 - sprite_2d.position.y) / 30.0)
        animated_sprite_2d.material.set_shader_parameter("y_threshold", (15 - sprite_2d.position.y) / 30.0)
    
    if !can_move:
        return
    
    var direction := Input.get_vector("Left", "Right", "Up", "Down")
    if Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
        direction = (get_global_mouse_position() - global_position).normalized()
    if direction == Vector2.ZERO && animated_sprite_2d.is_playing():
        animated_sprite_2d.pause()
        cpu_particles_2d.emitting = false
        animation_player.play("Default")
    elif direction != Vector2.ZERO:
        if !animated_sprite_2d.is_playing():
            animated_sprite_2d.play("default")
            animation_player.pause()
        if global_position.y > 100.0:
            cpu_particles_2d.emitting = true

    if direction.y > 0.0 && camera_2d.offset.y < 90.0:
        camera_2d.offset.y = min(90.0, camera_2d.offset.y + 90 * delta)
    elif direction.y <= 0.0 && camera_2d.offset.y > 0.0:
        camera_2d.offset.y = max(0.0, camera_2d.offset.y - 90 * delta / 4.0)

    if direction.y < 0 && !is_diving:
        direction.y = 0

    handle_dive_start(direction)
    direction = handle_collision(direction)
    direction = handle_out_of_bounds(direction)

    if global_position.y < 0.0:
        direction = Vector2(direction.x, 0.0)
        velocity = Vector2(get_velocity_component(direction.x, velocity.x, delta), velocity.y)
        velocity += get_gravity() * delta
    else:
        velocity = Vector2(get_velocity_component(direction.x, velocity.x, delta), get_velocity_component(direction.y, velocity.y, delta))

    hande_rotation_and_scale(direction, delta)

    move_and_slide()
    handle_light()
    
    $Label.text = "%s" % [floor(global_position.x)]

func handle_dive_start(direction: Vector2) -> void:
    if direction.y > 0 && !is_diving:
        is_diving = true
        audio_stream_player.stream = preload("res://Sounds/water.wav")
        audio_stream_player.play()
        sprite_2d.material.set_shader_parameter("y_threshold", 1.0)
        animated_sprite_2d.material.set_shader_parameter("y_threshold", 1.0)

func handle_collision(direction: Vector2) -> Vector2:
    if get_last_slide_collision() != null:
        direction = get_last_slide_collision().get_normal()
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

    return direction

func hande_rotation_and_scale(direction: Vector2, delta: float) -> void:
    if direction == Vector2.ZERO:
        return
    if velocity.y == 0.0 && (rotation == 0.0 || rotation_degrees == -180 || rotation_degrees == 180):
        if velocity.x > 0.0:
            rotation = 0.0
            scale = Vector2(1.0, 1.0)
        elif velocity.x < 0.0:
            rotation = - PI
            scale = Vector2(1.0, -1.0)
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
