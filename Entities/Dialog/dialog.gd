class_name Dialog extends Label

const pitch_variation: float = 0.1
const characters_per_second: int = 30
var timer: float = 0.0
var is_playing: bool = false

@onready var audio_stream_player: AudioStreamPlayer = $AudioStreamPlayer
@onready var animation_player: AnimationPlayer = $AnimationPlayer

func _ready() -> void:
    animation_player.animation_finished.connect(func(_anim: String): $/root/Game.continue_intro())

func _process(delta: float) -> void:
    if visible_characters != -1 && visible_characters < text.length():
        timer += delta
        visible_characters = characters_per_second * timer

        audio_stream_player.pitch_scale = 1.0 + randf_range(-pitch_variation, pitch_variation)
        audio_stream_player.play()
        if visible_characters >= text.length() && !animation_player.is_playing():
            animation_player.play("FadeOut")
            is_playing = false
            

func display_text(test_to_display: String) -> void:
    is_playing = true
    text = test_to_display
    visible_characters = 0
    timer = 0.0
