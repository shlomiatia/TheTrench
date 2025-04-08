class_name Game extends Node2D

@onready var dialog: Dialog = $CanvasLayer/Dialog
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var instructions: Label = $Instructions
var game_started: bool = false

func _ready() -> void:
    pass
func _process(_delta: float) -> void:
    pass

func continue_intro() -> void:
    animation_player.play("ContinueIntro")

func allow_input() -> void:
    $/root/Game/Submarine.can_move = true

func _input(event):
    if !game_started && event is InputEventKey and event.pressed:
        game_started = true
        dialog.display_next_text();
