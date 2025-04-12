class_name Sonar extends Node2D

const SEGMENTS = 1024

@export var radius: float = 0.0
@export var outline_color: Color = Color(1, 1, 1)
@export var line_width: float = 1.0

var skip_next: Array[bool] = []
var skip: Array[bool] = []
var ping_scene: PackedScene
var current_ping: Ping
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var submarine: Submarine = $/root/Game/Submarine
@onready var audio_stream_player: AudioStreamPlayer = $AudioStreamPlayer

func _ready() -> void:
    skip_next.resize(SEGMENTS + 1)
    skip.resize(SEGMENTS + 1)
    for i in SEGMENTS + 1:
        skip_next[i] = false
        skip[i] = false

    ping_scene = preload("res://Entities/Ping/Ping.tscn")


func ping(ping_global_position: Vector2) -> void:
    current_ping = ping_scene.instantiate()
    current_ping.init(SEGMENTS)
    get_tree().current_scene.add_child(current_ping)
    global_position = ping_global_position
    animation_player.play("Sonar")
    audio_stream_player.play()

    for i in skip.size():
        skip_next[i] = false
        skip[i] = false

func _draw() -> void:
    if not animation_player.is_playing():
        return
    var points: Array[Vector2] = []
    points.resize(SEGMENTS + 1)
    var angle_step = TAU / SEGMENTS

    for i in range(SEGMENTS + 1):
        if not skip[i]:
            var angle = i * angle_step
            points[i] = Vector2(cos(angle), sin(angle)) * radius

            var query = PhysicsRayQueryParameters2D.new()
            query.from = global_position
            query.to = global_position + points[i]
            query.collision_mask = 1

            var result = get_world_2d().direct_space_state.intersect_ray(query)

            if not result.is_empty():
                skip_next[i] = true
                var hit_position = result["position"] as Vector2
                points[i] = hit_position - global_position
                current_ping.add(i, hit_position)

    for i in range(SEGMENTS):
        if not skip[i] and not skip[i + 1]:
            draw_line(points[i], points[i + 1], outline_color, line_width)

    for i in skip.size():
        if skip_next[i]:
            skip[i] = true

func _process(_delta: float) -> void:
    if not animation_player.is_playing() && submarine.global_position.y > Constants.twilight_end && !submarine.is_trapped:
        ping(submarine.global_position + submarine.velocity.normalized() * Constants.sonar_offset)

    queue_redraw()
