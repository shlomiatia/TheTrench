class_name FaultyMeasurements extends HFlowContainer

@export var battery: int = 1000
@export var oxyxen: int = 1000
@onready var battery_label: Label = $Battery/Value
@onready var oxyxen_label: Label = $Oxygen/Value
@onready var submarine: Submarine = $/root/Game/Submarine
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var audio_stream_player: AudioStreamPlayer = $AudioStreamPlayer
@onready var game_animation_player: AnimationPlayer = $/root/Game/AnimationPlayer

var is_faulty: bool = false

func _ready() -> void:
    pass

func _process(_delta: float) -> void:
    if is_faulty:
        submarine.point_light_2d.energy = battery / 1000.0
        submarine.beam_light_2d.energy = battery / 1000.0
    else:
        battery = min(battery, floor(1000 - submarine.global_position.y / 10950 / 4 * 137))
        if submarine.global_position.y > 3500 * 4:
            oxyxen = 999
        elif submarine.global_position.y > 7000 * 4:
            oxyxen = 998
    @warning_ignore("integer_division")
    battery_label.text = "%s.%s" % [battery / 10, battery % 10] + "%"
    @warning_ignore("integer_division")
    oxyxen_label.text = "%s.%s" % [oxyxen / 10, oxyxen % 10] + "%"

func set_faulty() -> void:
    is_faulty = true
    animation_player.play("Fault")
    audio_stream_player.play()

func stop_movement() -> void:
    submarine.can_move = false

func play_outro() -> void:
    game_animation_player.play("PlayOutro")
    audio_stream_player.stop()