class_name Cthulhu extends Node2D

@onready var submarine: Submarine = $/root/Game/Submarine
@onready var eyes_red: Sprite2D = $EyesRed
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var camera_2d: Camera2D = $/root/Game/Submarine/Camera2D
@onready var faulty_measurements: FaultyMeasurements = $/root/Game/CanvasLayer/FaultyMeasurements

func _ready() -> void:
    pass

func _process(delta: float) -> void:
    var vector = submarine.global_position - global_position;
    var target_position: Vector2
    if vector.length() < 55.0:
        target_position = vector
    else:
        target_position = vector.normalized() * 55.0
    eyes_red.position = eyes_red.position + (target_position - eyes_red.position) * 1 * delta

func awake() -> void:
    animation_player.play("OpenEyes")
    camera_2d.start_screen_shake()

func set_faulty() -> void:
    faulty_measurements.set_faulty()