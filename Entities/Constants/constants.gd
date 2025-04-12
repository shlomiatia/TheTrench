extends Node2D

# Mariana tenrch is 11km, and the journey took 2.5 h
# 11000/2.5/60 = 73
var pixels_per_meter: float = 4.0
var max_speed: float = 292.0 # 73 m/s
var acceleration: float = 146.0
var deceleration: float = 584.0
var rotation_speed = 90.0
var twilight_start: float = 1600.0 # 200m * 8
var twilight_end: float = 8000.0 # 1000m * 8
var fish_min_speed: float = 20.0
var fish_max_speed: float = 40.0
var left_play_area: float = 400;
var right_play_area: float = 10000;
var type_sounds_per_second: float = 100
var sonar_offset: float = 30.0

var canvas_layer: CanvasLayer
var display_label: Label
var current_property_index: int = 0
var properties: Array = []

var timer = 0
const is_disabled = true

func _ready():
    if is_disabled:
        return
    properties = [
        "sonar_offset",
        "type_sounds_per_second",
        "max_speed",
        "acceleration",
        "deceleration",
        "rotation_speed",
        "fish_min_speed",
        "fish_max_speed",
    ]
    
    setup_ui()
    update_display()
    print_all_values()
    
    
func setup_ui():
    canvas_layer = CanvasLayer.new()
    
    $/root/Game.add_child(canvas_layer)
    
    display_label = Label.new()
    display_label.position = Vector2(10, 10)
    canvas_layer.add_child(display_label)


func _input(event: InputEvent):
    if is_disabled:
        return
    if event.is_action_pressed("ui_right"):
        current_property_index = (current_property_index + 1) % properties.size()
        update_display()
    
    elif event.is_action_pressed("ui_left"):
        current_property_index = (current_property_index - 1) % properties.size()
        if current_property_index < 0:
            current_property_index = properties.size() - 1
        update_display()
    elif event.is_action_pressed("ui_up"):
        timer = 0
        adjust_current_value(1)
    
    elif event.is_action_pressed("ui_down"):
        timer = 0
        adjust_current_value(-1)
        
func arrays_match(arr1, arr2):
    if arr1.size() != arr2.size():
        return false
    
    for i in range(arr1.size()):
        if arr1[i] != arr2[i]:
            return false
    
    return true
    
func _process(delta: float) -> void:
    if is_disabled:
        return
    if Input.is_action_pressed("ui_up"):
        timer += delta
        print(timer)
        if timer > 0.2:
            adjust_current_value(1)
    
    elif Input.is_action_pressed("ui_down"):
        timer += delta
        if timer > 0.2:
            adjust_current_value(-1)

func adjust_current_value(direction: int):
    var var_name = properties[current_property_index]
    
    set(var_name, get(var_name) + direction)
    
    update_display()
    print_all_values()

func update_display():
    var var_name = properties[current_property_index]
    var current_value = get(var_name)
    
    display_label.text = "%s: %.2f" % [var_name, current_value]

func print_all_values():
    print("\nCurrent Values:")
    print("----------------")
    for var_name in properties:
        var current_value = get(var_name)
        print("%s: %.2f" % [var_name, current_value])
    print("----------------")
