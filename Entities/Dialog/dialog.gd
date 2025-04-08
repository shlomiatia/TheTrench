class_name Dialog extends Label

const pitch_variation: float = 0.1
const characters_per_second: int = 30
var timer: float = 0.0
var audio_timer: float = 0.0
var is_playing: bool = false

@onready var audio_stream_player: AudioStreamPlayer = $AudioStreamPlayer
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var submarine: Submarine = $/root/Game/Submarine

var texts = [
    {"text": "Nearly 11,000 meters below sea level at its lowest point, the Marianna Trench is the deepest oceanic trench known to humans", "depth": 0},
    {"text": "I'm going to be the first person to explore it!", "depth": 0},
    {"text": "900m below sea level. That’s equivalent to the height of the world’s tallest building, the Burj Khalifa", "depth": 900},
    {"text": "1,800m below sea level. That’s the maximum depth of the Grand Canyon", "depth": 1800},
    {"text": "3,800m. That’s the depth they found the Titanic wreck at", "depth": 3800},
    {"text": "The trench should be close now...", "depth": 5000},
    {"text": "I've reached the trench opening", "depth": 6000},
    {"text": "I'm getting closer...", "depth": 7500},
    {"text": "I've reached 8,848m. As far from sea level as Everest", "depth": 8848},
    {"text": "10,000m below sea level. Commercial airplanes cruise at this altitude", "depth": 10000},
    {"text": "I made it! I'm the first person to see what's down here", "depth": 10950}
]

var text_index = 0

func _ready() -> void:
    animation_player.animation_finished.connect(animation_ended)

func _process(delta: float) -> void:
    if visible_characters != -1 && visible_characters < text.length():
        timer += delta
        audio_timer += delta
        @warning_ignore("narrowing_conversion")
        visible_characters = characters_per_second * timer

        var type_sounds_per_second: float = Constants.type_sounds_per_second / 1000.0
        if (audio_timer > type_sounds_per_second):
            audio_timer = audio_timer - type_sounds_per_second
            audio_stream_player.pitch_scale = 1.0 + randf_range(-pitch_variation, pitch_variation)
            audio_stream_player.play()
        if visible_characters >= text.length() && !animation_player.is_playing():
            animation_player.play("FadeOut")
            is_playing = false

    if text_index < texts.size() && texts[text_index]["depth"] != 0 && texts[text_index]["depth"] < submarine.global_position.y / Constants.pixels_per_meter:
        display_next_text()

func display_next_text() -> void:
    display_text(texts[text_index]["text"])
    text_index = text_index + 1
    if text_index >= texts.size():
        submarine.is_trapped = true

func display_text(test_to_display: String) -> void:
    is_playing = true
    text = test_to_display
    visible_characters = 0
    timer = 0.0
    audio_timer = 0.0
    animation_player.play("RESET")

func animation_ended(anim: String):
    if anim != "RESET":
        if text_index == 1:
            display_next_text()
        elif text_index == 2:
            $/root/Game.continue_intro()
        elif text_index == texts.size():
            $/root/Game/Cthulhu.awake()
            text_index = text_index + 1
