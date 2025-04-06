class_name Dialog extends Label

const pitch_variation: float = 0.1
const characters_per_second: int = 30
var timer: float = 0.0
var is_playing: bool = false

@onready var audio_stream_player: AudioStreamPlayer = $AudioStreamPlayer
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var submarine: Submarine = $/root/Game/Submarine

var texts = [
    {"text": "Reached 900m, the height of Burj khalifa", "depth": 900},
    {"text": "Reached 1,800m, the depth of the Grand Canyon", "depth": 1800},
    {"text": "Reached 3,800m, the depth of the Titanic wreck", "depth": 3800},
    {"text": "Reached the trench opening", "depth": 6000},
    {"text": "Reached 8,848m, the height of mount Everest", "depth": 8848},
    {"text": "Reached 10,000m, commercial airplanes cruise at this height", "depth": 10000},
    {"text": "Reached the trench end", "depth": 10950}
]

var text_index = 0

func _ready() -> void:
    animation_player.animation_finished.connect(animation_ended)

func _process(delta: float) -> void:
    if visible_characters != -1 && visible_characters < text.length():
        timer += delta
        @warning_ignore("narrowing_conversion")
        visible_characters = characters_per_second * timer

        audio_stream_player.pitch_scale = 1.0 + randf_range(-pitch_variation, pitch_variation)
        audio_stream_player.play()
        if visible_characters >= text.length() && !animation_player.is_playing():
            animation_player.play("FadeOut")
            is_playing = false

    if text_index < texts.size() && texts[text_index]["depth"] < submarine.global_position.y / Constants.pixels_per_meter:
        display_text(texts[text_index]["text"])
        text_index = text_index + 1

func display_text(test_to_display: String) -> void:
    is_playing = true
    text = test_to_display
    visible_characters = 0
    timer = 0.0
    animation_player.play("RESET")

func animation_ended(anim: String):
    prints(anim, text_index)
    if anim != "RESET":
        if text_index == 0:
            $/root/Game.continue_intro()
        elif text_index == texts.size():
            print($/root/Game/Cthulhu)
            $/root/Game/Cthulhu.awake()
