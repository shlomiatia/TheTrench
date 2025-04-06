class_name Fish extends CharacterBody2D

@export var texture: Texture2D
var speed: float
var direction: Vector2

@onready var sprite2d: Sprite2D = $Sprite2D
@onready var point_light_2d: PointLight2D = $Sprite2D/PointLight2D

func _ready() -> void:
    sprite2d.texture = texture
    speed = Constants.fish_min_speed + randf() * (Constants.fish_max_speed - Constants.fish_min_speed)
    if randi() % 2 == 0:
        direction = Vector2(-1.0, 0)
    else:
        direction = Vector2(1.0, 0.0)
    if sprite2d.texture.resource_path.contains("fish4"):
        point_light_2d.position = Vector2(-12, -5)
    elif sprite2d.texture.resource_path.contains("fish5"):
        point_light_2d.position = Vector2(-5, 0)
    elif sprite2d.texture.resource_path.contains("fish6"):
        point_light_2d.position = Vector2(-7, 0)
    else:
        point_light_2d.queue_free()

func _physics_process(_delta: float) -> void:
    velocity = direction * speed
    if velocity.x > 0.0:
        sprite2d.scale = Vector2(-1.0, 1.0)
    elif velocity.x < 0.0:
        sprite2d.scale = Vector2(1.0, 1.0)
    if move_and_slide():
        direction = Vector2(-direction.x, direction.y)
    if global_position.x < Constants.left_play_area:
        direction = Vector2(1.0, direction.y)
    if global_position.x > Constants.right_play_area:
        direction = Vector2(-1.0, direction.y)
