class_name Game extends Node2D

@onready var dialog: Dialog = $CanvasLayer/Dialog
@onready var animation_player: AnimationPlayer = $AnimationPlayer

func _ready() -> void:
    await get_tree().create_timer(1.0).timeout
    dialog.display_next_text();

func _process(_delta: float) -> void:
    pass

func continue_intro() -> void:
    animation_player.play("ContinueIntro")

func allow_input() -> void:
    $/root/Game/Submarine.can_move = true
