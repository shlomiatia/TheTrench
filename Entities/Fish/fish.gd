class_name Fish extends CharacterBody2D

@export var texture: Texture2D
var speed: float
var direction: Vector2

@onready var sprite2d = $Sprite2D

func _ready() -> void:
    sprite2d.texture = texture
    speed = Constants.fish_min_speed + randf() * (Constants.fish_max_speed - Constants.fish_min_speed)
    if randi() % 2 == 0:
        direction = Vector2(-1.0, 0)
    else:
        direction = Vector2(1.0, 0.0)

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
