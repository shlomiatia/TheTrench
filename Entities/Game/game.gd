class_name Game extends Node2D

@onready var dialog: Dialog = $CanvasLayer/Dialog
@onready var animation_player: AnimationPlayer = $AnimationPlayer
var was_intro_continued: bool = false

func _ready() -> void:
    await get_tree().create_timer(1.0).timeout
    dialog.display_text("Nearly 11,000 meters deep at its lowest point, the Marianna Trench is the deepest oceanic trench known to humans.");

func _process(_delta: float) -> void:
    pass

func continue_intro() -> void:
    if !was_intro_continued:
        was_intro_continued = true
        
        animation_player.play("ContinueIntro")

func allow_input() -> void:
    $/root/Game/Submarine.can_move = true
