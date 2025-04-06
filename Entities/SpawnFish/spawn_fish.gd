class_name SpawnFish extends Node

@onready var submarine: Submarine = $/root/Game/Submarine
var fish_scene: PackedScene = preload("res://Entities/Fish/Fish.tscn")

var spawn_infos = [
    {"textures": [preload("res://Textures/fish1.png"), preload("res://Textures/fish2.png"), preload("res://Textures/fish3.png")], "count_per_screen": 32, "depth": 0},
    {"textures": [preload("res://Textures/whale1.png")], "count_per_screen": 1, "depth": 165},
    {"textures": [preload("res://Textures/shark.png")], "count_per_screen": 3, "depth": 1000},
    {"textures": [preload("res://Textures/whale2.png")], "count_per_screen": 2, "depth": 2500},
    {"textures": [preload("res://Textures/fish4.png"), preload("res://Textures/fish5.png"), preload("res://Textures/fish6.png")], "count_per_screen": 16, "depth": 3500},
]
var spawn_info_index = 0

const width: float = 640.0
const height: float = 360.0

var screen_offsets: Array[Vector2] = [
    Vector2(-width, height),
    Vector2(0.0, height),
    Vector2(width, height),
    Vector2(width, 0.0),
]

func _ready() -> void:
    spawn_fish(submarine.global_position + Vector2(0.0, height / 2.0))

func _process(_delta) -> void:
    if spawn_info_index < spawn_infos.size() && spawn_infos[spawn_info_index]["depth"] < submarine.global_position.y / Constants.pixels_per_meter:
        spawn_fish(submarine.global_position)

func spawn_fish(center: Vector2) -> void:
    var spawn_info = spawn_infos[spawn_info_index]
    spawn_info_index = spawn_info_index + 1
    if spawn_info["count_per_screen"] == 1:
        var fish = spawn_one_fish(center, screen_offsets[1], spawn_info)
        fish.direction = Vector2(1.0, 0.0)
    else:
        for i in screen_offsets.size():
            var screen_offset = screen_offsets[i]
            for j in spawn_info["count_per_screen"]:
                spawn_one_fish(center, screen_offset, spawn_info)

func spawn_one_fish(center: Vector2, screen_offset: Vector2, spawn_info: Dictionary) -> Fish:
    var fish = fish_scene.instantiate() as Fish
    var random_offset = Vector2(width - randf() * width, height - randf() * height)
    fish.global_position = center + screen_offset + random_offset
    fish.texture = spawn_info["textures"][randi() % spawn_info["textures"].size()]
    add_child(fish)
    return fish
