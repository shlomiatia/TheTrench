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
    if (event is InputEventKey and event.is_pressed() and !event.is_echo()) || (event is InputEventMouseButton and event.is_pressed()):
        if !game_started:
            game_started = true
            dialog.display_next_text();
        if dialog.text_index < 3:
            if dialog.animation_player.is_playing():
                dialog.animation_player.seek(3.999)
            else:
                dialog.timer = 999.0
        if animation_player.is_playing():
            animation_player.seek(2.999)
            allow_input()
