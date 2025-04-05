class_name Ping extends Node2D

var segments: int = 256

@export var outline_color: Color = Color(1, 1, 1)
@export var alpha: float = 1.0
@export var line_width: float = 1.0

var points: Array[Vector2] = []
var to_draw: Array[bool] = []
@onready var animation_player: AnimationPlayer = $AnimationPlayer

func init(new_segments: int) -> void:
    segments = new_segments
    points.resize(segments + 1)
    to_draw.resize(segments + 1)
    for i in segments + 1:
        points[i] = Vector2.ZERO
        to_draw[i] = false

func _ready() -> void:
    animation_player = $AnimationPlayer
    animation_player.play("Ping")
    animation_player.animation_finished.connect(
        func(_anim_name): queue_free()
    )

func _draw() -> void:
    var color = Color(outline_color, alpha)
    for i in segments:
        if to_draw[i] and to_draw[i + 1]:
            if points[i].distance_to(points[i + 1]) < 20:
                draw_line(points[i], points[i + 1], color, line_width)

func _process(_delta: float) -> void:
    queue_redraw()

func add(i: int, vector2: Vector2) -> void:
    points[i] = vector2
    to_draw[i] = true
