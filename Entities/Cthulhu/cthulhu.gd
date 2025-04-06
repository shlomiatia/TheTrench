class_name Cthulhu extends Node2D

@onready var submarine: Submarine = $/root/Game/Submarine
@onready var eyes_red: Sprite2D = $EyesRed
@onready var animation_player: AnimationPlayer = $AnimationPlayer

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
    print("awake")
    animation_player.play("OpenEyes")